defmodule Caprice.Repo.Migrations.CreateCapdbVolumexml do
  use Ecto.Migration

  def change do
    create table(:capdb_volumexml) do
      add :barcode, :string
      add :orig_xml, :text
      add :s3_key, :string

      timestamps()
    end

  end
end
