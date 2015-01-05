$(".points-input").blur ->
  totalPoints()

$(document).ready ->
  totalPoints()

totalPoints = ->
  total = 0
  $(".points-input").each (i, o) ->
    pointsInt = parseInt($(o).val())
    total = total + pointsInt  unless isNaN(pointsInt)

  pointTotalDiv = $("#point-total")
  pointTotalDiv.html total
  if(parseInt(total) == 100)
    pointTotalDiv.addClass("success")
    pointTotalDiv.removeClass("alert")
  else
    pointTotalDiv.addClass("alert")
    pointTotalDiv.removeClass("success")
  return



