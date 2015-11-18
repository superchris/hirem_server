defmodule Hirem.CandidateTest do
  use Hirem.ModelCase

  alias Hirem.Candidate

  @valid_attrs %{email: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Candidate.changeset(%Candidate{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Candidate.changeset(%Candidate{}, @invalid_attrs)
    refute changeset.valid?
  end
end
