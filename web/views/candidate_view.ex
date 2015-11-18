defmodule Hirem.CandidateView do
  use Hirem.Web, :view

  def render("index.json", %{candidates: candidates}) do
    render_many(candidates, Hirem.CandidateView, "candidate.json")
  end

  def render("show.json", %{candidate: candidate}) do
    render_one(candidate, Hirem.CandidateView, "candidate.json")
  end

  def render("candidate.json", %{candidate: candidate}) do
    %{id: candidate.id,
      name: candidate.name,
      email: candidate.email}
  end
end
