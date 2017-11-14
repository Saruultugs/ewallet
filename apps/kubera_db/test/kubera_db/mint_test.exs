defmodule KuberaDB.MintTest do
  use ExUnit.Case
  import KuberaDB.Factory
  alias KuberaDB.{Repo, Mint}
  alias Ecto.Adapters.SQL.Sandbox

  setup do
    :ok = Sandbox.checkout(Repo)
  end

  describe "factory" do
    test "has a valid factory" do
      {res, _mint} = Mint.insert(params_for(:mint))
      assert res == :ok
    end
  end

  describe "insert/1" do
    test "generates a UUID in place of a regular integer ID" do
      {res, balance} = :mint |> params_for |> Mint.insert

      assert res == :ok
      assert String.match?(balance.id,
        ~r/[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}/)
    end

    test "generates the inserted_at and updated_at values" do
      {res, balance} = :mint |> params_for |> Mint.insert

      assert res == :ok
      assert balance.inserted_at != nil
      assert balance.updated_at != nil
    end

    test "prevents creation of a mint with a blank amount" do
      {result, changeset} =
        :mint
        |> params_for(%{amount: nil})
        |> Mint.insert

      assert result == :error
      assert changeset.errors ==
        [amount: {"can't be blank", [validation: :required]}]
    end

    test "prevents creation of a balance without a minted_token_id" do
      {result, changeset} =
        :mint
        |> params_for(%{minted_token_id: nil})
        |> Mint.insert

      assert result == :error
      assert changeset.errors ==
        [{:minted_token_id, {"can't be blank", [validation: :required]}}]
    end
  end
end
