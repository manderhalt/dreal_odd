#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
divwheelnav <- function(answer_question,width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    color_function = answer_question
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'divwheelnav',
    x,
    width = width,
    height = height,
    package = 'divwheel',
    elementId = elementId
  )
}

#' Shiny bindings for divwheelnav
#'
#' Output and render functions for using divwheelnav within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a divwheelnav
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name divwheelnav-shiny
#'
#' @export
divwheelnavOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'divwheelnav', width, height, package = 'divwheel')
}

#' @rdname divwheelnav-shiny
#' @export
renderDivwheelnav <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, divwheelnavOutput, env, quoted = TRUE)
}
