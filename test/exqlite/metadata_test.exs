defmodule Exqlite.MetadataTest do
  use ExUnit.Case

  alias Exqlite.Sqlite3

  describe ".compile_options/0" do
    test "returns a list of compile options" do
      assert is_list(Sqlite3.compile_options())
      assert length(Sqlite3.compile_options()) > 0
    end

    test "enables column metadata" do
      assert Enum.member?(Sqlite3.compile_options(), "ENABLE_COLUMN_METADATA")
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

  describe ".column_types/1" do
    test "returns the column types" do
      {:ok, conn} = Sqlite3.open(":memory:")

      :ok =
        Sqlite3.execute(conn, "create table test (id integer primary key, stuff text)")

      {:ok, stmt} = Sqlite3.prepare(conn, "SELECT * from sqlite_schema")
      {:row, _whatever} = Sqlite3.step(conn, stmt)
      {:ok, types} = Sqlite3.column_types(stmt)

      assert types == [
               :text,
               :text,
               :text,
               :integer,
               :text
             ]
    end
  end

  describe ".normalize_sql/1" do
    test "returns the normalized SQL" do
      goofy_sql = "sElEcT\n\t\t*\n\tFroM\n\t\tsqlite_schema"
      {:ok, conn} = Sqlite3.open(":memory:")
      {:ok, stmt} = Sqlite3.prepare(conn, goofy_sql)
      {:ok, normalized} = Sqlite3.normalize_sql(stmt)

      assert normalized == goofy_sql
    end
  end
end
