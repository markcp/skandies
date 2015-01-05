# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(".ranked").click ->
  if $(this).val() is "true"
    $(".rank").each (i,o) ->
      $(o).val(i+1)
  else
    $(".rank").val("0")
