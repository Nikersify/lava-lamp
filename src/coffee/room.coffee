socket = io(location.host)

socket.on 'server info', (data) ->
  console.log data
  $('.serverMessages').append("<div class='serverMessage'>#{data.msg}</div>")
