![Frenchfinity Logo](frenchfinity-logo.png)

This is the source code of **Frenchfinity 2.0**, the customizable version of
[Frenchfinity](https://frenchfinity.xyz) - the missing French cleat subsystem. It generates every
Frenchfinity part with OpenSCAD: wall anchors, plates and adapters plus a parametric holder for
(almost) every tool. See the latest version on MakerWorld:
https://makerworld.com/en/models/1448891-frenchfinity-2-0-customizable

## How Frenchfinity works

A wall anchor is a 3D printed French cleat that hooks onto the wooden cleats of your wall. Its front
carries a T-slot. Every holder carries the matching T-tongue on its back and slides into the slot
from the side. A piece of 1.75 mm filament in the small channel between tongue and slot removes any
play. Plates add height below short holders (French plate), mount holders without a cleat wall
(screw plate), on an IKEA Skadis pegboard or on the side of a welding table.

Every part is generated for exactly one tool: enter the size of your tool, print the holder and it
fits perfectly. All parts are generated in the orientation they hang on the wall.

## Parts

Pick the part with the `feature` parameter and adjust the parameter section of that part.

<!-- parts-table -->
| `feature` | Part | Use | Frenchfinity 1.0 |
|---|---|---|---|
| `wall_anchor` | Wall anchor | 3D printed French cleat with a slot, hooks onto the wall cleats, optional screw holes | Wall anchor |
| `french_plate` | French plate | Adds height below short holders so they lean against the wall cleat, optionally with several slots and tongues | French plate |
| `screw_plate` | Screw plate | Plate with a slot and countersunk screw holes for walls without cleats | Screw plate |
| `ikea_skadis_plate` | IKEA Skadis plate | Plate with a slot and hooks for the IKEA Skadis pegboard | Ikea Skadis plate |
| `welding_table_plate` | Welding table plate | Plate with a slot and pins for the holes of a D16/D28 welding table | new |
| `nussbaum_sl_smart_lift_plate` | Nussbaum SL smart lift plate | Base plate for the column of a Nussbaum SL smart lift | Nussbaum SL Smart Lift plate |
| `custom_base_adapter` | Custom base adapter | Two tongues back to back, connects wooden and printed parts with slots | Custom base plate adapter |
| `angle_adapter` | Angle adapter | Turns holders by an angle, e.g. by 90° so they face sideways | Angle adapter |
| `allen_key_holder` | Allen key holder | Holds one Allen key | Allen key holder |
| `bin` | Bin | Open bin for small parts with a low front wall | new |
| `bit_holder` | Bit holder | Grid of tilted holes for bits, drills and other round shanks | Bit holder |
| `box` | Box | Rectangular box for boxy tools and small parts | Rectangular box holder |
| `caliper_holder` | Caliper holder | Holds a caliper | Caliper holder |
| `can_holder` | Can holder | Holds spray and paint cans | Can holder |
| `crowbar_holder` | Crowbar holder | Holds long tools like crowbars | Crowbar holder |
| `einhell_battery_holder` | Einhell battery holder | Holds an Einhell Power X-Change battery | Einhell battery holder |
| `einhell_single_charger_holder` | Einhell single charger holder | Holds the Einhell Power X-Change single charger | Einhell single charger holder |
| `file_holder` | File holder | Holds a file by its handle | File holder |
| `glubot_holder` | GluBot holder | Holds a GluBot glue bottle upright | GluBot holder |
| `grid` | Grid holder | Box with a grid of compartments | Grid holder |
| `gridfinity_adapter` | Gridfinity adapter | Tilted Gridfinity baseplate for standard Gridfinity bins | Gridfinity adapter |
| `hammer_holder` | Hammer holder | Holds a hammer by its head, the handle hangs through a U-shaped gap | Hammer holder |
| `hook` | Hook | Hook for wires and small tools | Hook |
| `lifting_clamp_holder` | Lifting clamp holder | Holds lifting clamps | Lifting clamp holder |
| `locksmith_corner_holder` | Locksmith corner holder | Holds a try square | Locksmith corner holder |
| `meter_stick_holder` | Meter stick holder | Holds folding rules | Meter stick holder |
| `pliers_holder` | Pliers holder | Holds one pair of pliers by one of its handles | Pliers holder |
| `rectangular_tool_holder` | Rectangular tool holder | Holds tools with a flat rectangular head and a handle below it | Rectangular tool holder |
| `ring_wrench_holder` | Ring wrench holder | Holds ring wrenches on a stick | Ring wrench holder |
| `round_hanging_holder` | Round hanging holder | Holds round tools, brushes and cables | Round hanging holder |
| `sandpaper_holder` | Sandpaper holder | Keeps sandpaper sheets flat | Sandpaper holder |
| `screw_driver` | Screwdriver holder | Holds one screwdriver | Screwdriver holder |
| `small_hole_holder` | Small hole holder | Pin for tools with a small hanging hole | Small hole holder |
| `t_handle_holder` | T-handle holder | Holds tools with a T-handle | T-handle holder |
| `tablet_holder` | Tablet holder | Holds a tablet for manuals and tutorials | Tablet holder |
| `tape_holder` | Tape holder | Holds rolls of tape | Tape holder |
| `toilet_paper_holder` | Toilet paper holder | Holds a roll of paper | Toilet paper holder |
| `tray` | Tray | Open tray with rounded corners for small parts | new |
| `triangle_top_holder` | Triangle top holder | Holds triangular and odd shaped tools | Triangle top holder |
| `wolfcraft_accumobil_drilling_aid_holder` | Wolfcraft Accumobil drilling aid holder | Holds the Wolfcraft Accumobil drilling aid | Wolfcraft Accumobil drilling aid holder |
| `wolfcraft_corner_clamp_es22_holder` | Wolfcraft corner clamp ES22 holder | Holds the Wolfcraft ES22 corner clamp | Wolfcraft corner clamp ES22 holder |
| `wrench_holder` | Wrench holder | Holds a set of wrenches sorted by size | Wrench holder |
| `guide` | Guide | Sets up router and table saw to make wooden Frenchfinity parts | Guide |
| `tongue_cleaner` | Tongue cleaner | Cleans slots milled with the router | Tongue cleaner |
| `letter` | Letter | Letters and short words that hang on the wall | Letter |
<!-- /parts-table -->

## Compatibility and slot profile

The default slot profile `frenchfinity` reproduces the Frenchfinity 1.0 parts (Fusion 360) exactly,
so 1.0 and 2.0 parts can be mixed, and wooden parts milled with the M5 T-slot router bit fit as well:

| Dimension                                      | Slot     | Tongue    |
|------------------------------------------------|----------|-----------|
| Opening (neck) height x depth                  | 5.6 x 6.5 | 5.36 x 6.62 |
| Wide part (head) height x depth                | 8.5 x 4.5 | 8.26 x 4.26 |
| Distance from the top edge to the center line  | 10.194   | 10.194    |
| Filament channel                               | 1.7      | 1.7       |

Tongues are smaller by `print_tolerance` (0.12 mm) on every side. Further profiles:

- `openscad_v1_legacy`: parts generated with version 1 of this generator (labeled `v1scad`) used a
  slot with the neck dimensions swapped. Use this profile to print parts that fit those.
- `custom`: enter all slot dimensions yourself.

Every part was checked against the Frenchfinity 1.0 STL files: generated with the same parameters,
the parts overlap the 1.0 parts by 95 to 99.9 % of their volume (the 1.0 labels are engraved deeper).
Deliberate differences to Frenchfinity 1.0:

- Labels are engraved 0.6 mm deep (`text_depth`), lengths are always given in mm.
- Box: when the box is lower than the tongue, its floor reaches down to the tongue, so it prints flat.
- Grid holder: all cells have the same size, `grid_legacy_layout` restores the 1.0 layout.
- Bit holder: the holes never break through the back face (some 1.0 sizes drilled into it).
- Gridfinity adapter: `gridfinity_adapter_angle` is the real tilt, the 1.0 parts named `a10` are tilted by 20°.
- Guide: the slot has the size of the slot milled by the router bit (1.0: the size of a tongue).
- Letter: any text, the default font is Liberation Sans Bold (1.0: Arial Bold, set `letter_font`
  to `Arial:style=Bold` where it is installed).
- Einhell single charger holder and GluBot holder hang level (1.0 was slightly rotated), the tongue
  of the Wolfcraft holders is centered.

## Labels and file names

Like Frenchfinity 1.0, every part has the parameters it was generated with engraved, as short
abbreviations followed by their value (`w100` = width 100 mm), plus the version (`v2scad`). Disable
this with `render_text = false`.

OpenSCAD cannot set the name of an exported file, so the generator prints a file name proposal
containing the same abbreviations to the console. Look for `ECHO: "filename proposal:"`:

```
ECHO: "filename proposal:", "frenchfinity-wall-anchor-v2scad-w100-h40.4-d20-a45.stl"
```

## Development

The generator needs [BOSL2](https://github.com/BelfrySCAD/BOSL2), included as a git submodule:

```
git clone --recursive https://github.com/Bastelsaal/frenchfinity-openscad.git
# or, in an existing clone:
git submodule update --init
```

Open `src/frenchfinity.scad` in OpenSCAD and use the customizer. A recent development snapshot of
OpenSCAD with the Manifold backend renders every part within a few seconds; OpenSCAD 2021.01 works
as well, but is much slower.

| Path                  | Content                                                                 |
|-----------------------|-------------------------------------------------------------------------|
| `src/frenchfinity.scad` | Main file: all customizer parameters and the part selection            |
| `src/core/`           | Slot profile, tongues and slots, labels and file names, helpers         |
| `src/features/`       | One file per part                                                       |
| `build/build.sh`      | Merges everything into `dist/<timestamp>_frenchfinity.scad` for MakerWorld |
| `build/validate.sh`   | Renders every part with its default parameters and reports problems     |
| `.github/workflows/build.yml` | Builds and validates the MakerWorld file on GitHub                |

`build/validate.sh` takes an optional file (e.g. the merged file from `dist/`) and `--png` to render
preview images into `dist/validation/`.

### Automatic builds

Every push and pull request runs `build/build.sh` and `build/validate.sh` on GitHub (with the
current OpenSCAD development snapshot), for the sources and for the merged file. Every run offers the
merged file for download (Actions tab, open the run, section "Artifacts"). A pushed tag starting
with `v` publishes the file as a GitHub release:

```
git tag v2.0.0
git push origin v2.0.0
```

### Adding a part

- Create `src/features/<id>.scad` with a `module feature_<id>()` and add its parameters (section
  `/* [Name] */`, every name starting with `<id>_`), the include and the dispatcher entry to
  `src/frenchfinity.scad`.
- Coordinate system: `x` runs along the slot, `y = 0` is the mounting plane (back face of a holder,
  front face of an anchor or plate), holders extend to `+y`, anchors and plates to `-y`, `z` points
  up and the lowest point of a part is at `z = 0`.
- Use `ff_tongue(width, top)` for the tongue of a holder and subtract `ff_slot(width, top)` from
  anchors and plates, so the part follows the selected slot profile.
- Engrave the parameters with `ff_engrave_params()` and print the file name proposal with
  `ff_echo_file_name()`.
- Use `ff_offset_sweep()` instead of BOSL2's `offset_sweep()`: it builds the same shape from
  triangles, which OpenSCAD 2021.01 needs to render it reliably.
- Prefix every module, function and variable of a part with its id, all files share one namespace.

## Issues and feature requests

If you have any issues or feature requests, please open an issue on
the [GitHub repository](https://github.com/Bastelsaal/frenchfinity-openscad/issues).
I also welcome pull requests if you want to contribute to the project.

## License

Frenchfinity is licensed under the
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/).
You may use it in your workshop even if your workshop produces commercial products.
