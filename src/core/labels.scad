//
// Frenchfinity core: labels and file names
//
// Like Frenchfinity 1.0, every part carries the parameters it was generated with, written as short
// abbreviations followed by their value ("w100" for a width of 100 mm). The same abbreviations
// build the file name proposal that is printed to the console, because OpenSCAD cannot set the
// name of an exported file.
//
// Parameters are passed as a list of [abbreviation, value] pairs, e.g. [["w", 100], ["h", 60]].
//

ff_text_line_spacing = 1.45;
ff_text_min_size     = 2;

// Advance widths of the printable ASCII characters (space to ~) in 1/1000 em, measured on Liberation
// Sans Bold, the default font, which shares its metrics with Arial Bold. OpenSCAD renders text of
// size s with an em size of s / 0.72. Other characters count as wide as the widest umlaut.
ff_text_glyphs = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
ff_text_advances = [
    278, 333, 474, 556, 556, 889, 722, 238, 333, 333, 389, 584, 278, 333, 278, 278,
    556, 556, 556, 556, 556, 556, 556, 556, 556, 556, 333, 333, 584, 584, 584, 611,
    975, 722, 722, 722, 722, 667, 611, 778, 722, 278, 556, 722, 611, 833, 722, 778,
    667, 778, 722, 667, 611, 722, 667, 944, 667, 667, 611, 333, 278, 333, 584, 556,
    333, 556, 611, 556, 611, 556, 333, 611, 611, 278, 278, 556, 278, 889, 611, 611,
    611, 611, 389, 556, 333, 611, 556, 778, 556, 556, 500, 389, 280, 389, 584
];
ff_text_other_advance = 778;
ff_text_em_per_size   = 1 / 0.72;

// Rounds to two decimals and drops trailing zeros: 41.5 -> "41.5", 100 -> "100".
function ff_num(value) = is_num(value) ? str(round(value * 100) / 100) : str(value);

function ff_param(pair) = str(pair[0], ff_num(pair[1]));

// Parameters that only show up in the label and the file name when they differ from their default,
// e.g. parameters that the Frenchfinity 1.0 file names do not have. `params` is a list of
// [abbreviation, value, default] entries, the result the [abbreviation, value] pairs of the changed ones.
function ff_optional_params(params) = [for (param = params) if (param[1] != param[2]) [param[0], param[1]]];

function ff_join(list, separator, index = 0) =
    index >= len(list)
        ? ""
        : str(list[index], index < len(list) - 1 ? separator : "", ff_join(list, separator, index + 1));

function ff_version_label() = str("v", version, version_prefix);

// File name proposal, e.g. "frenchfinity-bit-holder-v2scad-r5-c2.stl" for name = "bit-holder".
function ff_file_name(name, params) =
    str(
        "frenchfinity-",
        name,
        "-",
        ff_join(concat([ff_version_label()], [for (pair = params) ff_param(pair)]), "-"),
        ".stl"
    );

// Lines engraved on a part: the version label followed by the parameters, `per_line` per line.
function ff_label_lines(params, per_line = 2) =
    let(
        texts = [for (pair = params) ff_param(pair)],
        count = len(texts)
    )
    concat(
        [ff_version_label()],
        count == 0
            ? []
            : [
                for (i = [0 : per_line : count - 1])
                    ff_join([for (j = [i : min(i + per_line, count) - 1]) texts[j]], " ")
            ]
    );

module ff_echo_file_name(name, params) {
    echo("filename proposal:", ff_file_name(name, params));
}

function ff_sum(list, index = 0) = index >= len(list) ? 0 : list[index] + ff_sum(list, index + 1);

function ff_char_advance(char) =
    let(index = search(char, ff_text_glyphs)[0])
    is_num(index) ? ff_text_advances[index] : ff_text_other_advance;

// Width of a line of text with text size 1. It is computed from the advance widths of the default
// font because only recent OpenSCAD versions can measure text (textmetrics()).
function ff_text_width(line) =
    len(line) == 0
        ? 0
        : ff_sum([for (i = [0 : len(line) - 1]) ff_char_advance(line[i])]) / 1000 * ff_text_em_per_size;

function ff_widest_line(lines) = len(lines) == 0 ? 0 : max([for (line = lines) ff_text_width(line)]);

// Largest text size (but not larger than `text_size`) that fits the lines into max_width x max_height.
function ff_fit_text_size(lines, max_width, max_height) =
    min(
        text_size,
        max_width / max(0.5, ff_widest_line(lines)),
        max_height / (max(1, len(lines)) * ff_text_line_spacing)
    );

// 2D block of centered text lines.
module ff_label_2d(lines, size) {
    spacing = size * ff_text_line_spacing;
    count   = len(lines);

    for (i = [0 : count - 1])
        translate([0, ((count - 1) / 2 - i) * spacing])
            text(lines[i], size = size, font = text_font, halign = "center", valign = "center", $fn = 12);
}

// Rotates the XY plane onto a face of a part: local +z becomes the outward normal of the face and
// local x / y become the reading direction for someone looking at that face.
module ff_face_orientation(face) {
    if (face == "front") {
        rotate([90, 0, 180]) children();
    } else if (face == "back") {
        rotate([90, 0, 0]) children();
    } else if (face == "top") {
        children();
    } else if (face == "bottom") {
        rotate([180, 0, 0]) children();
    } else if (face == "left") {
        rotate([90, 0, -90]) children();
    } else if (face == "right") {
        rotate([90, 0, 90]) children();
    } else {
        assert(false, str("Unknown face: ", face));
    }
}

// Cut body that engraves `lines` into a face of a part. `at` is the point on the face where the
// text block is centered, `rotation` turns the text within the face. Subtract it from the part.
// Text smaller than `ff_text_min_size` is skipped because it would not print legibly.
module ff_engrave(lines, at, face = "back", size = undef, rotation = 0) {
    text_height = is_undef(size) ? text_size : size;

    if (render_text && len(lines) > 0 && text_height >= ff_text_min_size) {
        translate(at)
            ff_face_orientation(face)
                rotate([0, 0, rotation])
                    translate([0, 0, -text_depth])
                        linear_extrude(height = text_depth + 0.1)
                            ff_label_2d(lines, text_height);
    }
}

// Engraves the version and parameter labels of a part, fitted into max_width x max_height (measured
// along the face before `rotation`). Without `per_line` the number of parameters per line (1 to 4)
// that gives the largest text is used. `rotations` (e.g. [0, 90]) lets it pick the best rotation, too.
module ff_engrave_params(params, at, face, max_width, max_height, per_line = undef, rotation = 0, rotations = undef) {
    options = [
        for (
            count = is_undef(per_line) ? [2, 1, 3, 4] : [per_line],
            angle = is_undef(rotations) ? [rotation] : rotations
        )
            let(
                lines   = ff_label_lines(params, count),
                sideway = abs(angle % 180) == 90
            )
            [
                sideway
                    ? ff_fit_text_size(lines, max_height, max_width)
                    : ff_fit_text_size(lines, max_width, max_height),
                count,
                angle
            ]
    ];
    best   = max([for (option = options) option[0]]);
    choice = [for (option = options) if (option[0] >= best - 1e-6) option][0];

    if (max_width > 0 && max_height > 0)
        ff_engrave(ff_label_lines(params, choice[1]), at, face, choice[0], choice[2]);
}
