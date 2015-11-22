defmodule Hirem.CandidateController do
  use Hirem.Web, :controller

  alias Hirem.Candidate
  alias Hirem.CandidateView

  plug :scrub_params, "candidate" when action in [:create, :update]

  def index(conn, _params) do
    candidates = Repo.all(Candidate)
    render(conn, "index.json", candidates: candidates)
  end

  def create(conn, %{"candidate" => candidate_params}) do
    changeset = Candidate.changeset(%Candidate{}, candidate_params)

    case Repo.insert(changeset) do
      {:ok, candidate} ->
        candidates = Repo.all(Candidate)
        Hirem.Endpoint.broadcast! "candidates:all", "change", %{candidates: CandidateView.render("index.json", %{candidates: candidates}) }
        conn
        |> put_status(:created)
        |> put_resp_header("location", candidate_path(conn, :show, candidate))
        |> render("show.json", candidate: candidate)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Hirem.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    candidate = Repo.get!(Candidate, id)
    render(conn, "show.json", candidate: candidate)
  end

  def update(conn, %{"id" => id, "candidate" => candidate_params}) do
    candidate = Repo.get!(Candidate, id)
    changeset = Candidate.changeset(candidate, candidate_params)

    case Repo.update(changeset) do
      {:ok, candidate} ->
        Hirem.Endpoint.broadcast! "candidates:#{candidate.id}", "change", %{candidate: CandidateView.render("show.json", %{candidate: candidate}) }
        render(conn, "show.json", candidate: candidate)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Hirem.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    candidate = Repo.get!(Candidate, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(candidate)

    send_resp(conn, :no_content, "")
  end
end
