locals_without_parens = [
  # Ecto.Migration
  add: 2,
  add: 3,
  create: 1,

  # Ecto.Query
  from: 2,

  # EEx
  function_from_file: 3,
  function_from_file: 4,
  function_from_file: 5,

  # Phoenix.Channel
  broadcast: 3,
  broadcast!: 3,
  intercept: 1,

  # Phoenix.Router
  connect: 3,
  connect: 4,
  delete: 3,
  delete: 4,
  forward: 2,
  forward: 3,
  forward: 4,
  get: 2,
  get: 3,
  get: 4,
  head: 3,
  head: 4,
  match: 4,
  match: 5,
  options: 3,
  options: 4,
  patch: 3,
  patch: 4,
  pipeline: 2,
  pipe_through: 1,
  plug: 1,
  plug: 2,
  post: 2,
  post: 3,
  post: 4,
  put: 3,
  put: 4,
  resources: 2,
  resources: 3,
  resources: 4,
  trace: 4,

  # Phoenix.Controller
  action_fallback: 1,
  render: 2,
  render: 3,
  render: 4,

  # Plug.Builder
  plug: 1,
  plug: 2,

  # Phoenix.Endpoint
  socket: 2,

  # Phoenix.Socket
  channel: 2,
  channel: 3,
  transport: 2,
  transport: 3,

  # Phoenix.ChannelTest
  assert_broadcast: 2,
  assert_broadcast: 3,
  assert_push: 2,
  assert_push: 3,
  assert_reply: 2,
  assert_reply: 3,
  assert_reply: 4,
  refute_broadcast: 2,
  refute_broadcast: 3,
  refute_push: 2,
  refute_push: 3,
  refute_reply: 2,
  refute_reply: 3,
  refute_reply: 4,

  # Phoenix.ConnTest
  assert_error_sent: 2,

  # Ecto.Schema
  belongs_to: 2,
  belongs_to: 3,
  field: 1,
  field: 2,
  field: 3,
  has_many: 2,
  has_many: 3,
  has_one: 2,
  has_one: 3
]

wildcard = fn glob -> Path.wildcard(glob, match_dot: true) end
matches = fn globs -> Enum.flat_map(globs, &wildcard.(&1)) end

# except = ["config/config.exs"]
except = []
inputs = ["*.exs", "{config,lib,test}/**/*.{ex,exs}"]

[
  inputs: matches.(inputs) -- matches.(except),
  line_length: 80,
  locals_without_parens: locals_without_parens,
  export: [locals_without_parens: locals_without_parens]
]
