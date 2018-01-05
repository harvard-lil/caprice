defmodule Caprice.Repo.Migrations.CreateCasesPages do
  use Ecto.Migration

  def change do
    create table(:capdb_pagexml_cases) do
      add :pagexml_id, references(:capdb_pagexml)
      add :casexml_id, references(:capdb_casexml)
    end

    create unique_index(:capdb_pagexml_cases, [:casexml_id, :pagexml_id])
  end
end
