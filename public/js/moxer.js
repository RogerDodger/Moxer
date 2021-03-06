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

/* public/js/src/draft.js */;
$(document).ready(function () {
   $('.Pack').on('click', '.Card', function (e) {
      $('.Card').not(this).removeClass('selected');
      $(this).toggleClass('selected');
   });

   var containers = [];
   var options = {
      direction: 'horizontal',
      accepts: function (el, target, source, sibling) {
         return target === source || !target.classList.contains('Pack');
      }
   };

   $('.Pack').each(function () { containers.push(this); });
   $('.Deck--Column').each(function () { containers.push(this); });

   var drake = dragula(containers, options);

   var changeDirection = function (_, container) {
      options.direction =
         container.classList.contains('Deck--Column')
            ? 'vertical'
            : 'horizontal';
   };

   drake.on('drag', changeDirection);
   drake.on('over', changeDirection);

   // Ensure that main and sideboard have exactly one blank column on the right at all times
   drake.on('drop', function () {
      $('.Draft--Deck--Main, .Draft--Deck--Side').each(function () {
         var last = this.children[this.children.length - 1];
         if (last.children.length !== 0) {
            var newCol = document.createElement('div');
            newCol.className = 'Deck--Column';
            containers.push(newCol);
            this.insertBefore(newCol, null);
         }
         else {
            while (last.previousElementSibling
               && !last.previousElementSibling.children.length)
            {
               this.removeChild(last.previousElementSibling);
            }
         }
      });
   });
});

/* public/js/src/misc.js */;
(function () {
   var foo = 'bar';
   console.log(foo);
})();

