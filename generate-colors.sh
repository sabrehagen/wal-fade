#!/bin/node

/**
 * Convert an hex color code (string) to a RGB array.
 * @param {string} hex String that should normally be an hexadecimal color code.
 * @returns An array of three integers that represent a RGB color.
 */
function hex2rgb(hex) {
  const match = hex.toString(16).match(/[a-f0-9]{8}|[a-f0-9]{6}|[a-f0-9]{3}/i);
  if (!match) {
    return [0, 0, 0];
  }
  let color_str = match[0];
  // Transparency is ignored
  if (color_str.length === 8) {
    color_str = color_str.slice(0, -2);
  }
  // Convert short hex code to normal length
  if (color_str.length === 3) {
    color_str = color_str.split('').map(char => {
      return char + char;
    }).join('');
  }
  const integer_clr = parseInt(color_str, 16);
  return [(integer_clr >> 16) & 0xFF, (integer_clr >> 8) & 0xFF, integer_clr & 0xFF];
}

/**
 * Convert RGB array to hexadecimal color code (string)
 * @param {array} rgb Array of three integers, representing a RGB color.
 * @returns Hexadecimal color code as an string of 6 characters.
 */
function rgb2hex(rgb) {
  const integer_clr = ((rgb[0] & 0xFF) << 16) + ((rgb[1] & 0xFF) << 8) + (rgb[2] & 0xFF);
  const string = integer_clr.toString(16).toUpperCase();
  return '000000'.substring(string.length) + string;
}

function getBlendingColors(color1, color2, step, fromHex, toHex) {
  let result = [color1];

  const c1 = fromHex(color1);
  const c2 = fromHex(color2);
  const step_count = parseInt(step) + 1;

  const step_a = (c2[0] - c1[0]) / step_count;
  const step_b = (c2[1] - c1[1]) / step_count;
  const step_c = (c2[2] - c1[2]) / step_count;

  for (let i = 1; i < step_count; i++) {
    let cn = [...c1];
    cn[0] = Math.round(cn[0] + (step_a * i));
    cn[1] = Math.round(cn[1] + (step_b * i));
    cn[2] = Math.round(cn[2] + (step_c * i));

    result.push(toHex(cn));
  }
  result.push(color2);
  return result;
}

function interpolate(color1, color2, step) {
  const colors = getBlendingColors(color1, color2, step, hex2rgb, rgb2hex);

  for (const color of colors) {
    console.log(color);
  }
}

interpolate(process.argv[2], process.argv[3], process.argv[4]);
