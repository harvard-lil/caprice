defmodule Caprice.Repo.Migrations.CreateCapdbCasexml do
  use Ecto.Migration

  def change do
    create table(:capdb_casexml) do
      add :case_id, :string
      add :s3_key, :string
      add :orig_xml, :text
      add :volume, references(:capdb_volumexml, on_delete: :nothing)

      timestamps()
    end

    create index(:capdb_casexml, [:volume])
  end
end
