defmodule Caprice.Caselaw.VolumeXML do
  use Ecto.Schema
  import Ecto.Changeset
  alias Caprice.Caselaw.VolumeXML


  schema "capdb_volumexml" do
    field :barcode, :string
    field :orig_xml, :string
    field :s3_key, :string
    has_many :capdb_casexmls, Caprice.Caselaw.CaseXML, foreign_key: :volume
    has_many :capdb_pagexmls, Caprice.Caselaw.PageXML, foreign_key: :volume

    timestamps()
  end

  @doc false
  def changeset(%VolumeXML{} = volume_xml, attrs) do
    volume_xml
    |> cast(attrs, [:barcode, :orig_xml, :s3_key])
    |> validate_required([:barcode, :orig_xml])
  end
end
