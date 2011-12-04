split = (val) ->
  val.split /,\s*/

extractLast = (term) ->
  split(term).pop()

$ ->

  recipients = $('#message_recipients').data('autocomplete-source')

  # don't navigate away from the field on tab when selecting an item
  $('#message_recipients').bind "keydown", (event) ->
    if event.keyCode == $.ui.keyCode.TAB and $(@).data("autocomplete").menu.active then event.preventDefault()
  $('#message_recipients').autocomplete
      minLength: 0
      source: (request, response) ->
        # delegate back to autocomplete, but extract the last term
        recipients = $('#message_recipients').data('autocomplete-source')
        console.log recipients
        response $.ui.autocomplete.filter(recipients, extractLast(request.term))
      focus: -> return false # prevent last value inserted on focus
      select: (event, ui) ->
        terms = split(@value)
        # remove the current input
        terms.pop()
        # add the selected item
        terms.push ui.item.value
        # add placeholder to get the comma-and-space at the end
        terms.push ""
        @value = terms.join ", "
        return false
