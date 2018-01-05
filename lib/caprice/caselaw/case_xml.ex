defmodule Caprice.Caselaw.CaseXML do
  use Ecto.Schema
  import Ecto.Changeset
  alias Caprice.Caselaw.CaseXML

  schema "capdb_casexml" do
    field :case_id, :string
    field :orig_xml, :string
    field :s3_key, :string
    #field :volume, :id
    belongs_to :capdb_volumexml, Caprice.Caselaw.VolumeXML, foreign_key: :volume
    many_to_many :capdb_pagexmls, Caprice.Caselaw.PageXML, join_through: "capdb_pagexml_cases",
                                      join_keys: [casexml_id: :id, pagexml_id: :id]


    timestamps()
  end

  @doc false
  def changeset(%CaseXML{} = case_xml, attrs) do
    case_xml
    |> cast(attrs, [:case_id, :s3_key, :orig_xml, :volume])
    |> validate_required([:case_id, :orig_xml, :volume])
  end
end
