defmodule Caprice.Ingest do

import Caprice.Caselaw

  @doc """
  Ingests caselaw from files
  """
  def ingest(asset_path) do
    get_files(asset_path) |>
    Enum.map(&process_file(&1)) |>
    Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  def get_files(asset_path) do
    cond do
      File.dir?(asset_path) -> Enum.map(Path.wildcard(asset_path <> "/*"), &get_files(&1) )
      String.contains?(asset_path, ["_CASEMETS_"]) -> [ {:casexml, asset_path} ]
      String.contains?(asset_path, ["_ALTO_"]) -> [ {:pagexml, asset_path} ]
      String.contains?(asset_path, ["_METS.xml"]) -> [ {:volumexml, asset_path} ]
      true -> [ nil ]
    end |>
    Enum.reject(fn(x) -> x == nil end)|>
    List.flatten
  end

  def process_file({:casexml, path}) do
    altos = extract_altos_from_xml_string(File.read!(path))
    case_id_string = get_identifier_from_path(path)
    insert_record = %{ orig_xml: File.read!(path), 
        case_id: case_id_string,
        volume: get_volume_from_identifier!(case_id_string).id }
    Caprice.Caselaw.create_case_xml(insert_record)
    add_case_pages(case_id_string, altos)
    :casexml
  end

  def process_file({:volumexml, path}) do
    insert_record = %{ orig_xml: File.read!(path), 
        barcode: get_identifier_from_path(path) }
    Caprice.Caselaw.create_volume_xml(insert_record)
    :volumexml
  end

  def process_file({:pagexml, path}) do
    page_id = get_identifier_from_path(path)
    insert_record = %{ orig_xml: File.read!(path), 
        barcode: page_id,
        volume: get_volume_from_identifier!(page_id).id }
    Caprice.Caselaw.create_page_xml(insert_record)
    :pagexml
  end

    @doc """
    Makes an xmerl structure then descends that structure until we get the urls
    """
  def extract_altos_from_xml_string(xml_string) do
    { doc, _ } = xml_string |> :binary.bin_to_list |> :xmerl_scan.string

    links = :xmerl_xpath.string('//fileGrp[@USE="alto"]/file/FLocat[@href=*]', doc)

    Enum.map(links, &Tuple.to_list(&1)) |>
    Enum.map(&Enum.at(&1, 7)) |>
    Enum.map(&Enum.at(&1, 1)) |>
    Enum.map(&Tuple.to_list(&1)) |>
    Enum.map(&Enum.at(&1, 8)) |>
    Enum.map(&get_identifier_from_path(&1)) |>
    Enum.map(&get_page_xml_by_barcode!(&1))
  end

  @doc """
    Makes an xmerl structure then descends that structure until we get the urls.

    ## Examples
      # case path
      iex> get_identifier_from_path("./this/dir/320441234567890_unredacted_CASEMETS_00123.xml")
      320441234567890_00123

      # page path
      iex> get_identifier_from_path("./this/dir/320441234567890_unredacted_ALTO_00123_0.xml")
      320441234567890_00123_0
      
      # volmets path
      iex> get_identifier_from_path("./this/dir/320441234567890_unredacted_METS.xml")
      320441234567890
    """
  def get_identifier_from_path(path) do
    path |> # eg ./this/dir/320441234567890_unredacted_CASEMETS_00123.xml 
    Path.basename() |> # 320441234567890_unredacted_CASEMETS_00123.xml 
    Path.rootname() |> # 320441234567890_unredacted_CASEMETS_00123
    String.split("_") |> # ["320441234567890", "unredacted", "CASEMETS", "00123"]
    List.delete_at(1) |> # ["320441234567890", "CASEMETS", "00123"]
    List.delete_at(1) |> # ["320441234567890", "00123"]
    Enum.join("_") # 320441234567890_00123
  end
end
