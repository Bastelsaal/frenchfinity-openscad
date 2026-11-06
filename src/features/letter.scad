//
// Letter
//
// A letter (or any short text) to build signs on the wall. The text is letter_thickness thick,
// letter_height is its cap height (the height of a capital letter like "H" in the default font).
//
// Like Frenchfinity 1.0 the letter carries a standard tongue at the standard height below the
// top edge, cut to the shape of the letter: the tongue runs along the whole text and is
// intersected with the outline of the letters, so it only exists where a letter has material in
// the top 14.5 mm below the top edge. A letter without a flat top (A, O, V ...) gets a shorter
// tongue that is still part of its body, every capital letter and digit hangs on its own tongue.
// With letter_alignment = "cap_height" (Frenchfinity 1.0) the cap height is the top edge, so all
// letters of a sign share the baseline and round letters (C, G, O, Q, S) reach a little above
// the anchor. "top" puts the highest point of the text on the top edge instead: use it for
// lowercase letters, symbols or fonts with lower capitals, which would otherwise not reach the
// tongue. Separate parts of a glyph (the dot on an "i", accents) only hold if they reach the
// tongue themselves.
//
// The text is centered on x = 0 (OpenSCAD cannot measure text), the baseline is at z = 0 with
// "cap_height", descenders and round letters reach slightly below it.
//

// Cap height per unit of the OpenSCAD text size (which is 0.72 em) of the font families this file
// knows: Liberation Sans 1409 / 2048 em, Arial 1466 / 2048 em (the font of Frenchfinity 1.0).
// Other fonts use the first entry, their capitals can come out a few percent larger or smaller.
letter_cap_heights = [["Liberation Sans", 0.9555], ["Arial", 0.9942]];

function letter_params() =
    concat(
        [["lh", letter_height], ["lt", letter_thickness]],
        letter_alignment == "top" ? [["top", ""]] : []
    );

// "Arial:style=Bold" -> "Arial"
function letter_font_family(font, i = 0) =
    i >= len(font) || font[i] == ":" ? "" : str(font[i], letter_font_family(font, i + 1));

function letter_cap_height_ratio() =
    let(found = [for (entry = letter_cap_heights) if (entry[0] == letter_font_family(letter_font)) entry[1]])
    len(found) > 0 ? found[0] : letter_cap_heights[0][1];

function letter_size() = letter_height / letter_cap_height_ratio();

// File name part: lowercase letters and digits, everything else becomes "_".
function letter_slug(text) =
    ff_join(
        [
            for (i = [0 : len(text) - 1])
                let(c = ord(text[i]))
                c >= 65 && c <= 90 ? chr(c + 32) :
                (c >= 97 && c <= 122) || (c >= 48 && c <= 57) ? text[i] :
                "_"
        ],
        ""
    );

// Characters that certainly reach the tongue with the cap height alignment.
function letter_is_simple(text) =
    len([for (i = [0 : len(text) - 1]) let(c = ord(text[i])) if (!((c >= 65 && c <= 90) || (c >= 48 && c <= 57))) 1]) == 0;

// The text in the (x, y) plane, reading along +x, its top edge at y = letter_height.
module letter_text_2d() {
    if (letter_alignment == "top")
        translate([0, letter_height])
            text(letter_text, size = letter_size(), font = letter_font, halign = "center", valign = "top");
    else
        text(letter_text, size = letter_size(), font = letter_font, halign = "center", valign = "baseline");
}

// The text standing in the mounting plane, readable from the front, from y = y0 to y = y1,
// its outline moved by `inset` to the inside.
module letter_prism(y0, y1, inset = 0) {
    ff_face_orientation("front")
        translate([0, 0, y0])
            linear_extrude(height = y1 - y0)
                offset(delta = -inset)
                    letter_text_2d();
}

// Tongue along the whole text, cut to the shape of the letters. It stays 0.01 mm inside the
// outline, faces in the same plane as the sides of the letter leave non manifold edges.
module letter_tongue() {
    length = len(letter_text) * letter_size() * 1.6 + 20;

    intersection() {
        translate([-length / 2, 0, 0])
            ff_tongue(length, letter_height);

        letter_prism(-ff_tongue_depth() - 1, ff_eps, inset = ff_eps);
    }
}

// Parameters on the back face, centered below the tongue, where most letters have their top
// stroke. Only the part that lies on the letter is engraved.
module letter_label(params) {
    area_top   = letter_height - ff_slot_bottom_offset() - 1.5;
    max_height = min(15, 0.075 * letter_height);

    ff_engrave_params(
        params,
        [0, 0, area_top - max_height / 2],
        "back",
        max_width  = 0.18 * letter_height,
        max_height = max_height
    );
}

module feature_letter() {
    assert(len(letter_text) > 0, "letter_text must not be empty.");
    assert(letter_height >= 2 * ff_min_height(), str("letter_height must be at least ", 2 * ff_min_height(), " mm to carry the tongue."));
    assert(letter_thickness >= 3, "letter_thickness must be at least 3 mm.");

    params = letter_params();

    ff_echo_file_name(str("letter-", letter_slug(letter_text)), params);

    if (letter_alignment == "cap_height" && !letter_is_simple(letter_text))
        echo("letter: only capital letters and digits are sure to reach the tongue, check the others or use letter_alignment = \"top\".");

    difference() {
        union() {
            letter_prism(0, letter_thickness);
            letter_tongue();
        }

        letter_label(params);
    }
}
