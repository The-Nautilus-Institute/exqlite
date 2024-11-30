defmodule Exqlite.MetadataTest do
  use ExUnit.Case

  alias Exqlite.Sqlite3

  describe ".compile_options/0" do
    test "returns a list of compile options" do
      assert is_list(Sqlite3.compile_options)
      assert length(Sqlite3.compile_options) > 0
    end
  end
end
