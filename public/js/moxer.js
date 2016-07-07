"use strict";

/* public/js/src/lib/date.js */;
Date.prototype.daysInMonth = function () {
   var month = this.getUTCMonth() + 1;
   if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
   }
   else if (month == 2) {
      return this.leapYear() ? 29 : 28;
   }
   else {
      return 31;
   }
};

/* public/js/src/misc.js */;
(function () {
   var foo = 'bar';
   console.log(foo);
})();

