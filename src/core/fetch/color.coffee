fetchValue  = require "./value.coffee"
randomColor = require "../../color/random.coffee"
validColor  = require "../../color/validate.coffee"
validObject = require "../../object/validate.coffee"
uniques     = require "../../util/uniques.coffee"

# Finds an object's color and returns random if it cannot be found
module.exports = (vars, id, level) ->

  level = vars.id.value unless level
  level = vars.id.nesting[level] if typeof level is "number"

  unless vars.color.value
    returnColor = getRandom vars, id, level
  else

    colors   = []
    i        = vars.id.nesting.indexOf(level)

    while i >= 0
      colorLevel = vars.id.nesting[i]
      if validObject(id)
        value = uniques id, vars.color.value, fetchValue, vars, colorLevel
        value = value[0] if value.length is 1
      else
        value = id

      if !(value instanceof Array) and value isnt undefined and value isnt null
        color = getColor(vars, id, value, level)
        colors.push color if colors.indexOf(color) < 0
        break
      i--

    returnColor = if colors.length is 1 then colors[0] else vars.color.missing

  returnColor

getColor = (vars, id, color, level) ->
  unless color
    if vars.color.value and typeof vars.color.valueScale is "function"
      return vars.color.valueScale(0)
    getRandom vars, id, level
  else unless vars.color.valueScale
    if validColor color then color else getRandom vars, color, level
  else
    vars.color.valueScale color

getRandom = (vars, c, level) ->
  c = fetchValue(vars, c, level) if validObject(c)
  c = c[0] if c instanceof Array
  randomColor c, vars.color.scale.value
