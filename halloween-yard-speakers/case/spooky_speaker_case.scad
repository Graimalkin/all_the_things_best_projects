// ============================================================
//  Spooky Speaker Case  (Halloween ESP32 speaker enclosure)
//
//  Fits:
//    * ESP32 DOIT DevKit V1 style board, 30-pin, micro-USB  (51.8 x 28.2 mm)
//    * NULLLAB NS4168 I2S amp module                        (38.4 x 22.4 mm, PH2.0 sockets)
//    * CQRobot enclosed speaker, front-firing               (70 x 31 x 16 mm)
//
//  Layout (top view, front wall at the bottom of the picture):
//      front : speaker, firing through the grille in the front wall
//      back  : ESP32 on the right (USB out the back wall), amp on the left
//
//  v2 (after first test print): ESP32 seat raised 5 mm for the jumper housings, pocket
//  tightened, side walls replaced by chamfered snap clips, speaker hold-downs on the lid.
//  v3 (after second print): ESP32 pocket 1 mm shorter, clips thicker/longer with a root gusset.
//
//  Print: box open side up, lid with the lip facing up.  No supports.
//  Render with:  openscad -o box.stl -D "part=\"box\"" spooky_speaker_case.scad
//                openscad -o lid.stl -D "part=\"lid\"" spooky_speaker_case.scad
// ============================================================

part   = "assembly";   // [box, lid, both, open, assembly]
grille = "jack";       // [jack, slots]   jack = pumpkin face, slots = plain horizontal slots
show_parts = true;     // ghost the electronics in the preview (assembly only)
explode = 0;           // lift the lid by this many mm in the assembly view

/* [Printer / fit] */
wall     = 2.4;        // side wall thickness
floor_t  = 2.0;        // floor thickness
lid_t    = 2.4;        // lid plate thickness
corner_r = 3;          // outside corner radius
$fn = 48;

/* [Speaker  (CQRobot 70x31x16)] */
spk_l = 70;            // length (runs left-right along the front wall)
spk_h = 31;            // height
spk_d = 16;            // depth (front to back)
spk_gap = 0.6;         // pocket clearance
spk_rib_h = 12;        // height of the ribs that hold the speaker
grille_w = 62;         // slot-grille width
grille_h = 24;         // slot-grille height

/* [ESP32 DOIT DevKit V1 (30-pin)] */
esp_l = 50.8;          // PCB length (USB end to antenna end). Nominal 51.8; v3 trimmed 1 mm after a test fit on my board
esp_w = 28.2;          // PCB width
esp_t = 1.6;           // PCB thickness
esp_gap = 0.5;         // pocket clearance (total, both sides)
esp_pcb_z = 22.5;      // PCB underside above the floor: leaves room for Dupont jumpers hanging off the pins (v1 was 17.5, too low)
esp_pad = 3.5;         // corner support pad size (sits under the corner mounting holes, clear of the pin headers)
esp_ledge = 1.5;       // depth of the support ledge under each short end of the PCB (USB end and antenna end)
esp_hold_gap = 0.4;    // lid hold-down post clearance above the PCB top
clip_len   = 10;       // snap clip length along the long edges of the PCB (v3: was 8)
clip_t     = 2.0;      // snap clip wall thickness (v3: was 1.6)
clip_root  = 1.5;      // gusset on the outside of each clip where it meets the floor
clip_hook  = 0.7;      // how far the clip hook overhangs the PCB edge
clip_land  = 0.6;      // vertical face on the hook tip, below the lead-in chamfer
clip_clear = 0.25;     // gap between PCB top and the underside of the hook
usb_w = 13;            // micro-USB cable cut-out width  (fits the cable's rubber overmould)
usb_h = 9.5;           // micro-USB cable cut-out height
usb_z_off = 1.5;       // cut-out centre height above the PCB top surface

/* [NS4168 amp module] */
amp_l = 38.4;          // PCB length (I2S input socket end to speaker socket end)
amp_w = 22.4;          // PCB width
amp_t = 1.6;
amp_hole_from_end = 15.2;  // the two M4 (Lego) holes, measured from the I2S-input end
amp_hole_span = 16;        // distance between the two holes
amp_standoff_h = 3;        // standoff height under the amp PCB
amp_peg_d = 4.5;           // peg that goes into the 4.8 mm Lego holes
amp_peg_h = 2.5;
amp_in_clear = 12;         // room behind the I2S input socket for the PH2.0 plug and its wires
amp_spk_clear = 8;         // room in front of the speaker socket for the speaker plug

/* [Lid] */
lip_h = 3;             // lid lip depth
lip_t = 1.6;           // lid lip thickness
lip_clear = 0.25;      // lip-to-wall clearance
boss_d = 5.5;          // corner screw boss diameter
boss_hole_d = 2.6;     // M3 self-tapping pilot hole
lid_hole_d = 3.4;      // lid through hole for M3
lid_cb_d = 6.5;        // counterbore for the screw head
lid_cb_h = 1.6;

// ---------------- derived layout (interior coordinates, origin = front-left interior corner, floor top) ----
spk_px = spk_l + spk_gap;          // speaker pocket, X
spk_py = spk_d + spk_gap;          // speaker pocket, Y
rib_t  = 2;
esp_pl = esp_l + esp_gap;          // ESP32 pocket, Y (board runs front-to-back)
esp_pw = esp_w + esp_gap;          // ESP32 pocket, X
edge   = boss_d + 1;               // keep-out along the walls for the corner bosses
lw     = 1.6;                      // locating wall thickness

W = spk_px + 2 * edge;                                             // interior width
D = spk_py + rib_t + amp_spk_clear + amp_l + amp_in_clear;         // interior depth
usb_cz = esp_pcb_z + esp_t + usb_z_off;                            // USB cut-out centre height
H = ceil(max(spk_h + 1, usb_cz + usb_h/2 + 3));                    // interior height: speaker, or 3 mm of wall above the USB cut-out

spk_x0 = edge;
esp_x1 = W - edge - lw;   esp_x0 = esp_x1 - esp_pw;
esp_y1 = D - 0.5;         esp_y0 = esp_y1 - esp_pl;
amp_x0 = edge + lw + 6;   amp_x1 = amp_x0 + amp_w;      // shifted right so the speaker plug clears the speaker bracket
amp_y0 = spk_py + rib_t + amp_spk_clear;   amp_y1 = amp_y0 + amp_l;

post_z = esp_pcb_z + esp_t + esp_hold_gap;   // lid hold-down posts reach down to here

echo(str("Interior ", W, " x ", D, " x ", H, " mm;  outside ", W + 2*wall, " x ", D + 2*wall, " x ", H + floor_t + lid_t, " mm"));

// ---------------- helpers ----------------
module rrect(w, d, r) { offset(r = r) offset(delta = -r) square([w, d]); }

function boss_pts() = [[boss_d/2, boss_d/2], [W - boss_d/2, boss_d/2],
                       [boss_d/2, D - boss_d/2], [W - boss_d/2, D - boss_d/2]];

// boss blended into its corner; extra = radial clearance
module boss_shape(p, extra = 0, h = H) {
    cx = p[0] < W/2 ? -0.1 : W;    cy = p[1] < D/2 ? -0.1 : D;
    hull() {
        translate([p[0], p[1], 0]) cylinder(d = boss_d + 2*extra, h = h);
        translate([cx, cy, 0]) cube([0.1, 0.1, h]);
    }
}

// ---------------- grille patterns (2D, centred on the speaker face) ----------------
module tri(b, h) { polygon([[-b/2, -h/2], [b/2, -h/2], [0, h/2]]); }

module jack_face() {
    for (s = [-1, 1]) translate([s * 15, 3.5]) tri(12, 9);         // eyes
    translate([0, -1.5]) tri(6, 4.5);                               // nose
    polygon([                                                       // jagged grin
        [-22, -4], [-14, -4], [-12, -6.5], [-10, -4], [-2, -4], [0, -6.5], [2, -4],
        [10, -4], [12, -6.5], [14, -4], [22, -4],
        [20, -7.5], [16, -10], [11, -11.5], [9, -11.5], [7, -8.5], [5, -11.8],
        [0, -12], [-5, -11.8], [-7, -8.5], [-9, -11.5], [-11, -11.5], [-16, -10], [-20, -7.5]
    ]);
}

module slot_face() {
    n = floor((grille_h + 2) / 4);
    for (i = [0 : n - 1])
        translate([-grille_w/2 + 1, -grille_h/2 + 1 + i * 4])
            hull() { circle(d = 2); translate([grille_w - 2, 0]) circle(d = 2); }
}

module grille_2d() { if (grille == "slots") slot_face(); else jack_face(); }

// ---------------- box ----------------
module shell() {
    difference() {
        translate([-wall, -wall, -floor_t])
            linear_extrude(H + floor_t) rrect(W + 2*wall, D + 2*wall, corner_r);
        linear_extrude(H + 1) rrect(W, D, max(corner_r - wall, 0.5));
    }
}

module speaker_ribs() {
    for (x = [spk_x0 - rib_t, spk_x0 + spk_px])                    // side ribs
        translate([x, 0, 0]) cube([rib_t, spk_py, spk_rib_h]);
    for (x = [spk_x0, spk_x0 + spk_px - 10])                        // rear brackets, middle left open for the cable
        translate([x, spk_py, 0]) cube([10, rib_t, spk_rib_h]);
}

// Snap clip: a free-standing wall (flexes from the floor) with a hook that overhangs the PCB edge.
// Profile is in XZ with x = 0 at the pocket edge, hook pointing +X; extruded along +Y for clip_len.
module snap_clip() {
    z_hb  = esp_pcb_z + esp_t + clip_clear;          // underside of the hook
    z_top = z_hb + clip_land + clip_hook;            // top of the lead-in chamfer
    pts = [[-clip_t - clip_root, 0], [0, 0], [0, z_hb], [clip_hook, z_hb], [clip_hook, z_hb + clip_land],
           [0, z_top], [-clip_t, z_top], [-clip_t, clip_root]];      // last two points: root gusset on the outside
    translate([0, clip_len, 0]) rotate([90, 0, 0]) linear_extrude(clip_len) polygon(pts);
}

module esp_cradle() {
    stop_h = esp_pcb_z + esp_t + 1.5;
    for (x = [esp_x0, esp_x1 - esp_pad]) for (y = [esp_y0, esp_y1 - esp_pad])   // corner pads
        translate([x, y, 0]) cube([esp_pad, esp_pad, esp_pcb_z]);
    for (y = [esp_y0, esp_y1 - esp_ledge])                                       // thin ledge under each short end of the PCB
        translate([esp_x0, y, 0]) cube([esp_pw, esp_ledge, esp_pcb_z]);
    for (y = [esp_y0 + 6, esp_y1 - 6 - clip_len]) {                              // snap clips, two per long edge, clear of the pads
        translate([esp_x0, y, 0]) snap_clip();
        translate([esp_x1, y, 0]) mirror([1, 0, 0]) snap_clip();
    }
    for (x = [esp_x0 - lw, esp_x1 - 8])                                          // antenna-end stops
        translate([x, esp_y0 - lw, 0]) cube([8 + lw, lw, stop_h]);
}

module amp_mount() {
    cx = (amp_x0 + amp_x1) / 2;
    hy = amp_y1 - amp_hole_from_end;
    for (dx = [-amp_hole_span/2, amp_hole_span/2]) translate([cx + dx, hy, 0]) {
        cylinder(d = 7.5, h = amp_standoff_h);
        cylinder(d = amp_peg_d, h = amp_standoff_h + amp_peg_h - 1);
        translate([0, 0, amp_standoff_h + amp_peg_h - 1]) cylinder(d1 = amp_peg_d, d2 = amp_peg_d - 1, h = 1);
    }
    translate([amp_x0, amp_y0, 0]) cube([amp_w, 3, amp_standoff_h]);                       // pad under the speaker-socket end
    translate([amp_x0 - lw, amp_y0 - lw, 0]) cube([amp_w + 2*lw, lw, amp_standoff_h + 1]); // low front lip (stays under the socket)
    for (x = [amp_x0 - lw, amp_x1])                                                        // side tabs
        translate([x, amp_y0 - lw, 0]) cube([lw, 8, amp_standoff_h + amp_t + 2]);
}

module bosses() { for (p = boss_pts()) boss_shape(p); }

module usb_cut() {
    cx = (esp_x0 + esp_x1) / 2;
    translate([cx - usb_w/2, D - 1, usb_cz - usb_h/2]) cube([usb_w, wall + 2, usb_h]);
}

module grille_cut() {
    translate([W/2, 1, spk_h/2]) rotate([90, 0, 0]) linear_extrude(wall + 2) grille_2d();
}

module box() {
    difference() {
        union() { shell(); speaker_ribs(); esp_cradle(); amp_mount(); bosses(); }
        usb_cut();
        grille_cut();
        for (p = boss_pts()) translate([p[0], p[1], H - 12]) cylinder(d = boss_hole_d, h = 13);
    }
}

// ---------------- lid (modelled in place on top of the box) ----------------
module lid_in_place() {
    difference() {
        union() {
            translate([-wall, -wall, H]) linear_extrude(lid_t) rrect(W + 2*wall, D + 2*wall, corner_r);
            translate([0, 0, H - lip_h]) linear_extrude(lip_h + 0.01) difference() {           // lip
                translate([lip_clear, lip_clear]) rrect(W - 2*lip_clear, D - 2*lip_clear, max(corner_r - wall, 0.5));
                translate([lip_clear + lip_t, lip_clear + lip_t]) rrect(W - 2*(lip_clear + lip_t), D - 2*(lip_clear + lip_t), 0.5);
            }
            for (x = [esp_x0 + 0.5, esp_x1 - 4.5])                                            // ESP32 hold-down posts (antenna end corners)
                translate([x, esp_y0 + 0.5, post_z]) cube([4, 4.5, H - post_z + 0.01]);
            for (x = [spk_x0 + spk_px * 0.25 - 4, spk_x0 + spk_px * 0.75 - 4])               // speaker hold-down posts
                translate([x, spk_py/2 - 2, spk_h + 0.5]) cube([8, 4, H - spk_h - 0.5 + 0.01]);
        }
        for (p = boss_pts()) translate([0, 0, H - lip_h - 1]) boss_shape(p, lip_clear, lip_h + 1);   // lip clears the bosses
        for (p = boss_pts()) translate([p[0], p[1], H - 1]) {
            cylinder(d = lid_hole_d, h = lid_t + 2);
            translate([0, 0, 1 + lid_t - lid_cb_h]) cylinder(d = lid_cb_d, h = lid_cb_h + 1);
        }
    }
}

module lid_for_print() { mirror([0, 0, 1]) translate([0, 0, -(H + lid_t)]) lid_in_place(); }

// ---------------- electronics, for the preview only ----------------
module parts_ghost() {
    // speaker
    color("DimGray", 0.6) translate([spk_x0 + spk_gap/2, spk_gap/2, 0]) cube([spk_l, spk_d, spk_h]);
    // ESP32
    ex = esp_x0 + esp_gap/2;  ey = esp_y0 + esp_gap/2;
    color("DarkGreen", 0.8) translate([ex, ey, esp_pcb_z]) cube([esp_w, esp_l, esp_t]);
    color("Silver", 0.8) translate([ex + (esp_w - 18)/2, ey + 1, esp_pcb_z + esp_t]) cube([18, 25.5, 3.2]);
    color("Silver", 0.8) translate([ex + esp_w/2 - 4, ey + esp_l - 6, esp_pcb_z + esp_t]) cube([8, 7, 2.9]);
    for (x = [ex + 1.4, ex + esp_w - 1.4]) color("Black", 0.8)
        translate([x - 1.27, ey + 6, esp_pcb_z - 2.5]) cube([2.54, 38.1, 2.5]);
    for (x = [ex + 1.4, ex + esp_w - 1.4]) color("Gold", 0.8)
        translate([x - 0.32, ey + 6, esp_pcb_z - 8.5]) cube([0.64, 38.1, 8.5]);
    // amp
    color("FireBrick", 0.8) translate([amp_x0, amp_y0, amp_standoff_h]) cube([amp_w, amp_l, amp_t]);
    color("WhiteSmoke", 0.9) translate([amp_x0 + amp_w/2 - 6.5, amp_y1 - 6, amp_standoff_h + amp_t]) cube([13, 6, 5]);
    color("WhiteSmoke", 0.9) translate([amp_x0 + amp_w/2 - 3.5, amp_y0, amp_standoff_h + amp_t]) cube([7, 6, 5]);
}

// ---------------- output ----------------
if (part == "box") box();
if (part == "open") { box(); if (show_parts) parts_ghost(); }   // box with electronics, no lid
if (part == "lid") lid_for_print();
if (part == "both") { box(); translate([W + 2*wall + 10, 0, 0]) lid_for_print(); }
if (part == "assembly") {
    box();
    color("SlateGray", 0.5) translate([0, 0, explode]) lid_in_place();
    if (show_parts) parts_ghost();
}
