#include QMK_KEYBOARD_H

#define _DVORAK 0
#define _LOWER 1
#define _RAISE 2
#define _ADJUST 3
#define _EFES 4

#define RAISE MO(_RAISE)
#define LOWER MO(_LOWER)
#define ADJUST MO(_ADJUST)
#define EFES MO(_EFES)

enum custom_keycodes {
  MACRO1 = SAFE_RANGE,
  MACRO2,
  MACRO3
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [_DVORAK] = LAYOUT_6x6(
      KC_ESC   , KC_1    ,KC_2     , KC_3    , KC_4   , KC_5    ,                  KC_6  ,  KC_7   , KC_8   , KC_9   ,  KC_0   ,  KC_BSPC        , 
      KC_TAB   , KC_QUOT ,KC_COMM  , KC_DOT  , KC_P   , KC_Y    ,                  KC_F  ,  KC_G   , KC_C   , KC_R   ,  KC_L   ,  KC_BSPC        , 
      KC_ESC   , KC_A    ,KC_O     , KC_E    , KC_U   , KC_I    ,                  KC_D  ,  KC_H   , KC_T   , KC_N   ,  KC_S   ,  KC_MINS        , 
      KC_LSFT  , KC_SCLN ,KC_Q     , KC_J    , KC_K   , KC_X    ,                  KC_B  ,  KC_M   , KC_W   , KC_V   ,  KC_Z   ,  RSFT_T(KC_SLSH),
      KC_NO    , KC_LT   ,KC_GT    , KC_DOWN , KC_UP  , RAISE   ,                  LOWER ,  KC_LEFT, KC_RGHT, KC_LBRC,  KC_RBRC,  KC_NO          , 
                                               KC_SPC , KC_LALT ,KC_LGUI ,      KC_ESC , KC_RALT, KC_ENT, 
                                                                 ADJUST,        EFES, 
                                                                 KC_LCTL,       KC_CAPS
    ),
    [_LOWER] = LAYOUT_6x6(
      KC_NO    , KC_F1   ,KC_F2    , KC_F3   , KC_F4  , KC_F5   ,                   KC_F6 ,  KC_F7 ,  KC_F8 , KC_F9  ,  KC_F10 , KC_BSPC ,
      KC_NO    , KC_EXLM ,KC_AT    , KC_HASH , KC_DLR , KC_PERC ,                   KC_CIRC, KC_AMPR, KC_LPRN, KC_RPRN, KC_ASTR, KC_BSPC,
      KC_NO    , KC_TILD ,KC_DLR   , KC_LT   , KC_RPRN, KC_GRV  ,                   KC_MINS, KC_EQL, KC_LCBR, KC_RCBR, KC_BSLS, KC_NO,
      KC_NO    , KC_PERC ,KC_CIRC  , KC_GT   , KC_RBRC, KC_TILD ,                   KC_UNDS, KC_PLUS, KC_LBRC, KC_RBRC, KC_PIPE, KC_NO,
      KC_NO    , KC_NO   ,KC_NO    , KC_NO   , KC_NO  , KC_TRNS ,                   KC_TRNS, KC_PDOT, KC_P0, KC_PEQL, KC_NO, KC_NO,
                                               KC_TRNS, KC_TRNS ,KC_TRNS,      KC_TRNS , KC_TRNS, KC_TRNS, 
                                                                 KC_TRNS,      KC_TRNS,
                                                                 KC_TRNS,      KC_TRNS
    ),
    [_RAISE] = LAYOUT_6x6(
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,                                      KC_NO, KC_NO, KC_PSLS, KC_PAST, KC_PMNS, KC_BSPC,
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,                                      KC_NO, KC_P7, KC_P8, KC_P9, KC_PPLS, KC_NO, 
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,                                      KC_NO, KC_P4, KC_P5, KC_P6, KC_PCMM, KC_NO, 
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,                                      KC_NO, KC_P1, KC_P2, KC_P3, KC_PEQL, KC_NO,
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,                               LGUI(KC_SPC), KC_NO, KC_P0, KC_PDOT, KC_PENT, KC_NO,
                                  KC_NO, KC_NO, KC_NO,                      KC_NO, KC_NO, KC_NO,
                                                KC_NO,                      KC_NO, 
                                                KC_NO,                      KC_NO
    ),
    [_ADJUST] = LAYOUT_6x6(
      KC_NO, KC_NO, KC_NO, MACRO3,MACRO2, MACRO1,                                    KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_STOP,                                  KC_NO, KC_BRIU, KC_VOLU, KC_MUTE, KC_NO, KC_NO,
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_MPLY,                                  KC_MSTP, KC_BRID, KC_VOLD, KC_NO, KC_NO, KC_NO,
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_MPRV,                                  KC_MNXT, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,                                    KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,
                            KC_NO, KC_NO, KC_NO,                                    KC_NO, KC_NO, KC_NO, 
                                          KC_NO,                                    KC_NO, 
                                          KC_NO,                                    KC_NO
   ),
   [_EFES] = LAYOUT_6x6(
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,                                    KC_NO, KC_F10, KC_F11, KC_F12, KC_NO, KC_NO,
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,                                    KC_NO, KC_F7 , KC_F8 , KC_F9 , KC_NO, KC_NO,
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,                                    KC_NO, KC_F4 , KC_F5 , KC_F6 , KC_NO, KC_NO,
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,                                    KC_NO, KC_F1 , KC_F2 , KC_F3 , KC_NO, KC_NO,
      KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,                                    KC_NO, KC_NO , KC_NO , KC_NO , KC_NO, KC_NO,
                            KC_NO, KC_NO, KC_NO,                                    KC_NO, KC_NO, KC_NO, 
                                          KC_NO,                                    KC_NO, 
                                          KC_NO,                                    KC_NO
   )
};

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
    case MACRO1:
      if (record->event.pressed) {
        SEND_STRING("mariocampbellr@gmail.com");
      }
      return false;
      break;
    case MACRO2:
      if (record->event.pressed) {
        SEND_STRING("mcampbellrojas@tevora.com");
      }
      return false;
      break;
    case MACRO3:
      if (record->event.pressed) {
        SEND_STRING("mC@mPbEl1");
      }
      return false;
      break;
  }
  return true;
}
