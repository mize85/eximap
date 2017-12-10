defmodule Eximap.Imap.Request do
  @moduledoc """

  """
  defstruct tag: "TAG", command: nil, params: []

  def add_tag(req, tag), do: %Eximap.Imap.Request{req | tag: tag}
  def raw(req), do: "#{req.tag} #{req.command} #{Enum.join(req.params, " ")}\r\n"

  @doc ~S"""
  The NOOP command always succeeds.  It does nothing.

    iex> {:ok, pid} = Eximap.Imap.Client.start_link()
    iex> req = Eximap.Imap.Request.noop()
    iex> Eximap.Imap.Client.execute(pid, req) |> Map.from_struct()
    %{body: ["EX1 OK NOOP completed (0.000 + 0.000 secs)."], error: nil,
    message: "NOOP completed (0.000 + 0.000 secs).", partial: false,
    request: %Eximap.Imap.Request{command: "NOOP", params: [], tag: "EX1"},
    status: "OK"}

  """
  def noop(), do: %Eximap.Imap.Request{command: "NOOP"}

  @doc ~S"""
  The CAPABILITY command requests a listing of capabilities that the server supports.
  The server MUST send a single untagged CAPABILITY response with "IMAP4rev1" as one of the listed
  capabilities before the (tagged) OK response.

  Client and server implementations MUST implement the STARTTLS, LOGINDISABLED, and AUTH=PLAIN capabilities.

    iex> {:ok, pid} = Eximap.Imap.Client.start_link()
    iex> req = Eximap.Imap.Request.capability()
    iex> Eximap.Imap.Client.execute(pid, req)
    %Eximap.Imap.Response{body: ["EX1 OK Capability completed (0.000 + 0.000 secs).",
    "* CAPABILITY IMAP4rev1 LITERAL+ SASL-IR LOGIN-REFERRALS ID ENABLE IDLE SORT SORT=DISPLAY THREAD=REFERENCES THREAD=REFS THREAD=ORDEREDSUBJECT MULTIAPPEND URL-PARTIAL CATENATE UNSELECT CHILDREN NAMESPACE UIDPLUS LIST-EXTENDED I18NLEVEL=1 CONDSTORE QRESYNC ESEARCH ESORT SEARCHRES WITHIN CONTEXT=SEARCH LIST-STATUS BINARY MOVE SPECIAL-USE QUOTA"],
    error: nil, message: "Capability completed (0.000 + 0.000 secs).",
    partial: false,
    request: %Eximap.Imap.Request{command: "CAPABILITY", params: [],
    tag: "EX1"}, status: "OK"}

  """
  def capability(), do: %Eximap.Imap.Request{command: "CAPABILITY"}

  @doc ~S"""
  The AUTHENTICATE command indicates a SASL authentication mechanism to the server. If the server supports the requested
  authentication mechanism, it performs an authentication protocol exchange to authenticate and identify the client.
  """
  def authenticate(mechanism), do: %Eximap.Imap.Request{command: "AUTHENTICATE", params: [mechanism]}

  @doc ~S"""
  The LOGIN command identifies the client to the server and carries
  the plaintext password authenticating this user.
  """
  def login(user, pass), do: %Eximap.Imap.Request{command: "LOGIN", params: [user, pass]}

  @doc ~S"""

    iex> {:ok, pid} = Eximap.Imap.Client.start_link()
    iex> req = Eximap.Imap.Request.list()
    iex> Eximap.Imap.Client.execute(pid, req)
    %Eximap.Imap.Response{body: ["EX1 OK List completed (0.000 + 0.000 secs).",
     "* LIST (\\HasNoChildren) \".\" INBOX",
     "* LIST (\\HasNoChildren \\Sent) \".\" Sent",
     "* LIST (\\HasNoChildren \\Trash) \".\" Trash",
     "* LIST (\\HasNoChildren \\Drafts) \".\" Drafts",
     "* LIST (\\HasNoChildren \\Junk) \".\" Junk"], error: nil,
    message: "List completed (0.000 + 0.000 secs).", partial: false,
    request: %Eximap.Imap.Request{command: "LIST",
     params: ["\"\"", "\"%\""], tag: "EX1"}, status: "OK"}
  """
  def list(reference\\"\"\"", mailbox \\ "\"%\""), do: %Eximap.Imap.Request{command: "LIST", params: [reference, mailbox]}
  def lsub(reference\\"\"\"", mailbox \\ "\"\""), do: %Eximap.Imap.Request{command: "LSUB", params: [reference, mailbox]}

  @doc ~S"""
  The LOGOUT command informs the server that the client is done with
  the connection.  The server MUST send a BYE untagged response
  before the (tagged) OK response, and then close the network
  connection.

    iex> {:ok, pid} = Eximap.Imap.Client.start_link()
    iex> req = Eximap.Imap.Request.logout()
    iex> Eximap.Imap.Client.execute(pid, req)
    %Eximap.Imap.Response{body: ["EX1 OK Logout completed (0.000 + 0.000 secs).",
             "* BYE Logging out"], error: nil,
            message: "Logout completed (0.000 + 0.000 secs).", partial: false,
            request: %Eximap.Imap.Request{command: "LOGOUT", params: [],
             tag: "EX1"}, status: "OK"}
  """
  def logout(), do: %Eximap.Imap.Request{command: "LOGOUT"}

  @doc ~S"""

    iex> {:ok, pid} = Eximap.Imap.Client.start_link()
    iex> req = Eximap.Imap.Request.select("INBOX")
    iex> Eximap.Imap.Client.execute(pid, req)
    %Eximap.Imap.Response{body: ["EX1 OK [READ-WRITE] Select completed (0.000 + 0.000 secs).",
     "* OK [HIGHESTMODSEQ 1] Highest",
     "* OK [UIDNEXT 1] Predicted next UID",
     "* OK [UIDVALIDITY 1512767411] UIDs valid", "* 0 RECENT",
     "* 0 EXISTS",
     "* OK [PERMANENTFLAGS (\\Answered \\Flagged \\Deleted \\Seen \\Draft \\*)] Flags permitted.",
     "* FLAGS (\\Answered \\Flagged \\Deleted \\Seen \\Draft)"],
    error: nil,
    message: "[READ-WRITE] Select completed (0.000 + 0.000 secs).",
    partial: false,
    request: %Eximap.Imap.Request{command: "SELECT", params: ["INBOX"],
     tag: "EX1"}, status: "OK"}
  """
  def select(name), do: %Eximap.Imap.Request{command: "SELECT", params: [name]}
  def subscribe(name), do: %Eximap.Imap.Request{command: "SUBSCRIBE", params: [name]}
  def unsubscribe(name), do: %Eximap.Imap.Request{command: "UNSUBSCRIBE", params: [name]}

  @doc ~S"""

    iex> {:ok, pid} = Eximap.Imap.Client.start_link()
    iex> req = Eximap.Imap.Request.examine("INBOX")
    iex> Eximap.Imap.Client.execute(pid, req)
    %Eximap.Imap.Response{body: ["EX1 OK [READ-ONLY] Examine completed (0.000 + 0.000 secs).",
     "* OK [HIGHESTMODSEQ 1] Highest",
     "* OK [UIDNEXT 1] Predicted next UID",
     "* OK [UIDVALIDITY 1512767411] UIDs valid", "* 0 RECENT",
     "* 0 EXISTS", "* OK [PERMANENTFLAGS ()] Read-only mailbox.",
     "* FLAGS (\\Answered \\Flagged \\Deleted \\Seen \\Draft)"],
    error: nil,
    message: "[READ-ONLY] Examine completed (0.000 + 0.000 secs).",
    partial: false,
    request: %Eximap.Imap.Request{command: "EXAMINE", params: ["INBOX"],
    tag: "EX1"}, status: "OK"}
  """
  def examine(name), do: %Eximap.Imap.Request{command: "EXAMINE", params: [name]}
  def create(name), do: %Eximap.Imap.Request{command: "CREATE", params: [name]}
  def delete(name), do: %Eximap.Imap.Request{command: "DELETE", params: [name]}
  def status(name, opts), do: %Eximap.Imap.Request{command: "STATUS", params: [name, opts]}
  def append(name, [] = opts), do: %Eximap.Imap.Request{command: "APPEND", params: [name, Enum.join(opts, "")]}
  def rename(name, new_name), do: %Eximap.Imap.Request{command: "RENAME", params: [name, new_name]}

  def check(), do: %Eximap.Imap.Request{command: "CHECK", params: []}
  def starttls(), do: %Eximap.Imap.Request{command: "STARTTLS", params: []}
  def close(), do: %Eximap.Imap.Request{command: "CLOSE", params: []}
  def expunge(), do: %Eximap.Imap.Request{command: "EXPUNGE", params: []}
  def search(flags), do: %Eximap.Imap.Request{command: "SEARCH", params: flags}
  def fetch(sequence, flags), do: %Eximap.Imap.Request{command: "FETCH", params: [sequence, flags]}
  def store(sequence, item, value), do: %Eximap.Imap.Request{command: "STORE", params: [sequence, item, value]}
  def copy(sequence, mailbox), do: %Eximap.Imap.Request{command: "COPY", params: [sequence, mailbox]}
  def uid(params), do: %Eximap.Imap.Request{command: "UID", params: params}
end