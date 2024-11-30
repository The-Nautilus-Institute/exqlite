defmodule Exqlite.MetadataTest do
  use ExUnit.Case

  alias Exqlite.Sqlite3

  describe ".compile_options/0" do
    test "returns a list of compile options" do
      assert is_list(Sqlite3.compile_options)
      assert length(Sqlite3.compile_options) > 0
    end

    test "enables column metadata" do
      assert Enum.member?(Sqlite3.compile_options, "ENABLE_COLUMN_METADATA")
    end
  end

  describe ".column_origins/1" do
    test "returns the column origins" do
      {:ok, conn} = Sqlite3.open(":memory:")
      {:ok, stmt} = Sqlite3.prepare(conn, "SELECT * from sqlite_schema")
      {:ok, origins} = Sqlite3.column_origins(stmt)
      assert origins == [
        {"main", "sqlite_master", "type"},
        {"main", "sqlite_master", "name"},
        {"main", "sqlite_master", "tbl_name"},
        {"main", "sqlite_master", "rootpage"},
        {"main", "sqlite_master", "sql"}
      ]
    end
  end
end
