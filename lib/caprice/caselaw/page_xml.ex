defmodule Caprice.Caselaw.PageXML do
  use Ecto.Schema
  import Ecto.Changeset
  alias Caprice.Caselaw.PageXML

  schema "capdb_pagexml" do
    field :barcode, :string
    field :orig_xml, :string
    field :s3_key, :string
    #field :volume, :id
    belongs_to :capdb_volumexml, Caprice.Caselaw.VolumeXML, foreign_key: :volume
    many_to_many :capdb_casexmls, Caprice.Caselaw.CaseXML, join_through: "capdb_pagexml_cases",
                                      join_keys: [pagexml_id: :id, casexml_id: :id]
    timestamps()
  end

  @doc false
  def changeset(%PageXML{} = page_xml, attrs) do
    page_xml
    |> cast(attrs, [:barcode, :orig_xml, :s3_key, :volume])
    |> validate_required([:barcode, :orig_xml, :volume])
  end
end

