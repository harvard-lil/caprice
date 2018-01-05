defmodule Caprice.Repo.Migrations.CreatePageXml do
  use Ecto.Migration

  def change do
    create table(:capdb_pagexml) do
      add :barcode, :string
      add :orig_xml, :text
      add :s3_key, :string
      add :volume, references(:capdb_volumexml, on_delete: :nothing)

      timestamps()
    end

    create index(:capdb_pagexml, [:volume])
  end
end
