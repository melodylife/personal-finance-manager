exports.ramString = function(length){
  len = length || 32;
  var $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnOpqrstuvwxyz0123456789';
  var maxPos = $chars.length;
  var ramStr = '';
  for (i = 0; i < length; i++) {
    ramStr += $chars.charAt(Math.floor(Math.random() * maxPos));
  }
  return ramStr;

}



