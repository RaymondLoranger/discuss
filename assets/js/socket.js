// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

// Now that you are connected, you can join channels with a topic:
const wireCommentsChannel = topicId => {
  let channel = socket.channel(`comments:${topicId}`, {})
  channel.join()
    .receive("ok", resp => {
      console.log(`Joined "comments:${topicId}" successfully 😊`, resp)
      renderComments(resp.comments)
    })
    .receive("error", resp => {
      console.log(`Unable to join "comments:${topicId}" 🙁`, resp)
    })
  document.querySelector("#add-comment").addEventListener("click", () => {
    const content = document.querySelector("#comment").value
    channel.push("comments:add", {
      content
    })
  })
  channel.on(`comments:${topicId}:new`, renderComment)
}

function renderComments(comments) {
  const renderedComments = comments.map(comment => {
    return commentTemplate(comment)
  })
  document.querySelector("#comments").innerHTML = renderedComments.join('')
}

function renderComment(event) {
  const renderedComment = commentTemplate(event.comment)
  document.querySelector("#comments").innerHTML += renderedComment
}

function commentTemplate(comment) {
  let email = 'Anonymous'
  if (comment.user) {
    email = comment.user.email
  }
  return `
    <li class="collection-item">
      ${comment.content}
      <div class="secondary-content">
        ${email}
      </div>
    </li>
  `
}

window.wireCommentsChannel = wireCommentsChannel

// export default socket