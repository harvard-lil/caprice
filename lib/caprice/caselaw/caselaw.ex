defmodule Caprice.Caselaw do
  @moduledoc """
  The Caselaw context.
  """

  import Ecto.Query, warn: false
  alias Caprice.Repo

  alias Caprice.Caselaw.VolumeXML

  @doc """
  Returns the list of capdb_volumexml.

  ## Examples

      iex> list_capdb_volumexml()
      [%VolumeXML{}, ...]

  """
  def list_capdb_volumexml do
    Repo.all(VolumeXML)
  end

  @doc """
  Gets a single volume_xml.

  Raises `Ecto.NoResultsError` if the Volume xml does not exist.

  ## Examples

      iex> get_volume_xml!(123)
      %VolumeXML{}

      iex> get_volume_xml!(456)
      ** (Ecto.NoResultsError)

  """
  def get_volume_xml!(id), do: Repo.get!(VolumeXML, id)

  @doc """
  Gets a single volume_xml.

  Raises `Ecto.NoResultsError` if the Volume xml does not exist.

  ## Examples

      iex> get_volume_xml!(123)
      %VolumeXML{}

      iex> get_volume_xml!(456)
      ** (Ecto.NoResultsError)

  """
  def get_volume_xml_by_barcode!(barcode), do: Repo.get_by!(VolumeXML, barcode: barcode)

  def get_volume_xml_with_associations_by_barcode!(barcode) do
    Repo.get_by!(VolumeXML, barcode: barcode) 
    |> Repo.preload(:capdb_casexmls)
    |> Repo.preload(:capdb_pagexmls)
  end


  @doc """
  Creates a volume_xml.

  ## Examples

      iex> create_volume_xml(%{field: value})
      {:ok, %VolumeXML{}}

      iex> create_volume_xml(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_volume_xml(attrs \\ %{}) do
    %VolumeXML{}
    |> VolumeXML.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a volume_xml.

  ## Examples

      iex> update_volume_xml(volume_xml, %{field: new_value})
      {:ok, %VolumeXML{}}

      iex> update_volume_xml(volume_xml, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_volume_xml(%VolumeXML{} = volume_xml, attrs) do
    volume_xml
    |> VolumeXML.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a VolumeXML.

  ## Examples

      iex> delete_volume_xml(volume_xml)
      {:ok, %VolumeXML{}}

      iex> delete_volume_xml(volume_xml)
      {:error, %Ecto.Changeset{}}

  """
  def delete_volume_xml(%VolumeXML{} = volume_xml) do
    Repo.delete(volume_xml)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking volume_xml changes.

  ## Examples

      iex> change_volume_xml(volume_xml)
      %Ecto.Changeset{source: %VolumeXML{}}

  """
  def change_volume_xml(%VolumeXML{} = volume_xml) do
    VolumeXML.changeset(volume_xml, %{})
  end

  alias Caprice.Caselaw.PageXML

  @doc """
  Returns the list of page_xml.

  ## Examples

      iex> list_page_xml()
      [%PageXML{}, ...]

  """
  def list_page_xml do
    Repo.all(PageXML)
  end

  @doc """
  Gets a single page_xml.

  Raises `Ecto.NoResultsError` if the Page xml does not exist.

  ## Examples

      iex> get_page_xml!(123)
      %PageXML{}

      iex> get_page_xml!(456)
      ** (Ecto.NoResultsError)

  """
  def get_page_xml!(id), do: Repo.get!(PageXML, id)


  @doc """
  Gets a single page_xml by barcode.

  Raises `Ecto.NoResultsError` if the Page xml does not exist.

  ## Examples

      iex> get_page_xml!(123)
      %PageXML{}

      iex> get_page_xml!(456)
      ** (Ecto.NoResultsError)

  """
  def get_page_xml_by_barcode!(barcode), do: Repo.get_by!(PageXML, barcode: barcode)
  @doc """
  Creates a page_xml.

  ## Examples

      iex> create_page_xml(%{field: value})
      {:ok, %PageXML{}}

      iex> create_page_xml(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_page_xml(attrs \\ %{}) do
    %PageXML{}
    |> PageXML.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a page_xml.

  ## Examples

      iex> update_page_xml(page_xml, %{field: new_value})
      {:ok, %PageXML{}}

      iex> update_page_xml(page_xml, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_page_xml(%PageXML{} = page_xml, attrs) do
    page_xml
    |> PageXML.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PageXML.

  ## Examples

      iex> delete_page_xml(page_xml)
      {:ok, %PageXML{}}

      iex> delete_page_xml(page_xml)
      {:error, %Ecto.Changeset{}}

  """
  def delete_page_xml(%PageXML{} = page_xml) do
    Repo.delete(page_xml)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking page_xml changes.

  ## Examples

      iex> change_page_xml(page_xml)
      %Ecto.Changeset{source: %PageXML{}}

  """
  def change_page_xml(%PageXML{} = page_xml) do
    PageXML.changeset(page_xml, %{})
  end

  alias Caprice.Caselaw.CaseXML

  @doc """
  Returns the list of capdb_casexml.

  ## Examples

      iex> list_capdb_casexml()
      [%CaseXML{}, ...]

  """
  def list_capdb_casexml do
    Repo.all(CaseXML)
  end

  @doc """
  Gets a single case_xml.

  Raises `Ecto.NoResultsError` if the Case xml does not exist.

  ## Examples

      iex> get_case_xml!(123)
      %CaseXML{}

      iex> get_case_xml!(456)
      ** (Ecto.NoResultsError)

  """
  def get_case_xml!(id), do: Repo.get!(CaseXML, id)


  @doc """
  Gets a single case_xml by its case_id

  Raises `Ecto.NoResultsError` if the Case xml does not exist.

  ## Examples

      iex> get_case_xml_by_caseid!("32044026226753_0014")
      %CaseXML{}

      iex> get_case_xml_by_caseid!("32044026226753_9014")
      ** (Ecto.NoResultsError)

  """
  def get_case_xml_by_caseid!(case_id), do: Repo.get_by!(CaseXML, case_id: case_id)
  
  def get_case_with_pages_by_caseid!(case_id), do: Repo.get_by!(CaseXML, case_id: case_id) |> Repo.preload(:capdb_pagexmls)



  @doc """
  Gets a single case_xml by its case_id

  ## Examples

      iex> get_case_xml_by_caseid!("32044026226753_0014")
      %CaseXML{}

      iex> get_case_xml_by_caseid!("32044026226753_9014")
      ** (Ecto.NoResultsError)

  """
  def get_case_xml_by_caseid(case_id), do: Repo.get_by(CaseXML, case_id: case_id)

  @doc """
  Creates a case_xml.

  ## Examples

      iex> create_case_xml(%{field: value})
      {:ok, %CaseXML{}}

      iex> create_case_xml(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_case_xml(attrs \\ %{}) do
    %CaseXML{}
    |> CaseXML.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a case_xml.

  ## Examples

      iex> update_case_xml(case_xml, %{field: new_value})
      {:ok, %CaseXML{}}

      iex> update_case_xml(case_xml, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_case_xml(%CaseXML{} = case_xml, attrs) do
    case_xml
    |> CaseXML.changeset(attrs)
    |> Repo.update()
  end


  @doc """
  Adds pages to a case

  ## Examples

      iex> add_case_pages(%CaseXML{} = case_xml, [page1, page2, page3])
      
      iex> update_case_xml(case_xml, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def add_case_pages(case_id_string, page_list) do
    case_xml = get_case_xml_by_caseid!(case_id_string) |> Repo.preload(:capdb_pagexmls)
    Ecto.Changeset.change(case_xml) |>
    Ecto.Changeset.put_assoc(:capdb_pagexmls, page_list) |>
    Repo.update!
  end

  @doc """
  Deletes a CaseXML.

  ## Examples

      iex> delete_case_xml(case_xml)
      {:ok, %CaseXML{}}

      iex> delete_case_xml(case_xml)
      {:error, %Ecto.Changeset{}}

  """
  def delete_case_xml(%CaseXML{} = case_xml) do
    Repo.delete(case_xml)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking case_xml changes.

  ## Examples

      iex> change_case_xml(case_xml)
      %Ecto.Changeset{source: %CaseXML{}}

  """
  def change_case_xml(%CaseXML{} = case_xml) do
    CaseXML.changeset(case_xml, %{})
  end


  @doc """

  """
  def get_volume_from_identifier!(identifier) do
    identifier |> # eg ./this/dir/320441234567890_unredacted_CASEMETS_00123.xml 
    String.split("_") |> # ["320441234567890", "unredacted", "CASEMETS", "00123"]
    Enum.take(1) |> # ["320441234567890", "CASEMETS", "00123"]
    List.to_string() |>
    get_volume_xml_by_barcode!()
  end
end
