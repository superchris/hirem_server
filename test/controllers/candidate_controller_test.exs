defmodule Hirem.CandidateControllerTest do
  use Hirem.ConnCase

  alias Hirem.Candidate
  @valid_attrs %{email: "some content", name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, candidate_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    candidate = Repo.insert! %Candidate{}
    conn = get conn, candidate_path(conn, :show, candidate)
    assert json_response(conn, 200)["data"] == %{"id" => candidate.id,
      "name" => candidate.name,
      "email" => candidate.email}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, candidate_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, candidate_path(conn, :create), candidate: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Candidate, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, candidate_path(conn, :create), candidate: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    candidate = Repo.insert! %Candidate{}
    conn = put conn, candidate_path(conn, :update, candidate), candidate: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Candidate, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    candidate = Repo.insert! %Candidate{}
    conn = put conn, candidate_path(conn, :update, candidate), candidate: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    candidate = Repo.insert! %Candidate{}
    conn = delete conn, candidate_path(conn, :delete, candidate)
    assert response(conn, 204)
    refute Repo.get(Candidate, candidate.id)
  end
end
