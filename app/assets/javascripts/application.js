
//= require jquery
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require_tree .

  $(document).ready(function(){
    $('.datepicker').datepicker({
      format:'dd/mm/yyyy'
    });
  });
