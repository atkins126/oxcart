/*
   Started On:    22.09.2013.
*/

var log = {
   onMouseUp: function(event) {
      var els = this.parentNode.getElementsByClassName('section');

      if(els.length > 0) {
         var el = els[0];
         
         if(el.hasAttribute("hidden"))
            el.removeAttribute("hidden")
         else
            el.setAttribute("hidden", "true");
      }
   },
   
   collapseAll: function() {
      var els = document.getElementsByClassName('section');

      console.log('Collapsing '+els.length+' sections');
      
      for(var i = 0; i < els.length; ++i) {
         els[i].setAttribute("hidden", "true");
      }
      
      console.log('done');
   },
   
   expandAll: function() {
      var els = document.getElementsByClassName('section');

      for(var i = 0; i < els.length; ++i) {
         els[i].removeAttribute("hidden");
      }
   },

   onLoad: function() {
      var els = document.getElementsByClassName('sectiontitle');

      for(var i = 0; i < els.length; ++i) {
         els[i].addEventListener('mouseup', log.onMouseUp, false);
      }

      console.log('Got '+els.length+' sections');
   }
};

window.addEventListener('load', log.onLoad, false);