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

   // Ensure that main and sideboard have exactly one blank column at all times
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

   var i = 1;
   $('.Draft--Header').on('click', function () {
      var $q = $('.Draft--Queue');
      if ($q.children().length >= 7) {
         $q.empty();
      }
      $q.prepend('<div class="Draft--Queue--Pack Pack-' + i + ' "></div>');
      i = i % 15 + 1;
   });
});
