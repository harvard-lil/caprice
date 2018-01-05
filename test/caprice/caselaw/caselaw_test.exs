defmodule Caprice.CaselawTest do
  use Caprice.DataCase

  alias Caprice.Caselaw

  describe "capdb_volumexml" do
    alias Caprice.Caselaw.VolumeXML

    @valid_attrs %{barcode: "some barcode", orig_xml: "some orig_xml", s3_key: "some s3_key"}
    @update_attrs %{barcode: "some updated barcode", orig_xml: "some updated orig_xml", s3_key: "some updated s3_key"}
    @invalid_attrs %{barcode: nil, orig_xml: nil, s3_key: nil}

    def volume_xml_fixture(attrs \\ %{}) do
      {:ok, volume_xml} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Caselaw.create_volume_xml()

      volume_xml
    end

    test "list_capdb_volumexml/0 returns all capdb_volumexml" do
      volume_xml = volume_xml_fixture()
      assert Caselaw.list_capdb_volumexml() == [volume_xml]
    end

    test "get_volume_xml!/1 returns the volume_xml with given id" do
      volume_xml = volume_xml_fixture()
      assert Caselaw.get_volume_xml!(volume_xml.id) == volume_xml
    end

    test "create_volume_xml/1 with valid data creates a volume_xml" do
      assert {:ok, %VolumeXML{} = volume_xml} = Caselaw.create_volume_xml(@valid_attrs)
      assert volume_xml.barcode == "some barcode"
      assert volume_xml.orig_xml == "some orig_xml"
      assert volume_xml.s3_key == "some s3_key"
    end

    test "create_volume_xml/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Caselaw.create_volume_xml(@invalid_attrs)
    end

    test "update_volume_xml/2 with valid data updates the volume_xml" do
      volume_xml = volume_xml_fixture()
      assert {:ok, volume_xml} = Caselaw.update_volume_xml(volume_xml, @update_attrs)
      assert %VolumeXML{} = volume_xml
      assert volume_xml.barcode == "some updated barcode"
      assert volume_xml.orig_xml == "some updated orig_xml"
      assert volume_xml.s3_key == "some updated s3_key"
    end

    test "update_volume_xml/2 with invalid data returns error changeset" do
      volume_xml = volume_xml_fixture()
      assert {:error, %Ecto.Changeset{}} = Caselaw.update_volume_xml(volume_xml, @invalid_attrs)
      assert volume_xml == Caselaw.get_volume_xml!(volume_xml.id)
    end

    test "delete_volume_xml/1 deletes the volume_xml" do
      volume_xml = volume_xml_fixture()
      assert {:ok, %VolumeXML{}} = Caselaw.delete_volume_xml(volume_xml)
      assert_raise Ecto.NoResultsError, fn -> Caselaw.get_volume_xml!(volume_xml.id) end
    end

    test "change_volume_xml/1 returns a volume_xml changeset" do
      volume_xml = volume_xml_fixture()
      assert %Ecto.Changeset{} = Caselaw.change_volume_xml(volume_xml)
    end
  end

  describe "page_xml" do
    alias Caprice.Caselaw.PageXML

    @valid_attrs %{barcode: "some barcode", orig_xml: "some orig_xml", s3_key: "some s3_key"}
    @update_attrs %{barcode: "some updated barcode", orig_xml: "some updated orig_xml", s3_key: "some updated s3_key"}
    @invalid_attrs %{barcode: nil, orig_xml: nil, s3_key: nil}

    def page_xml_fixture(attrs \\ %{}) do
      {:ok, page_xml} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Caselaw.create_page_xml()

      page_xml
    end

    test "list_page_xml/0 returns all page_xml" do
      page_xml = page_xml_fixture()
      assert Caselaw.list_page_xml() == [page_xml]
    end

    test "get_page_xml!/1 returns the page_xml with given id" do
      page_xml = page_xml_fixture()
      assert Caselaw.get_page_xml!(page_xml.id) == page_xml
    end

    test "create_page_xml/1 with valid data creates a page_xml" do
      assert {:ok, %PageXML{} = page_xml} = Caselaw.create_page_xml(@valid_attrs)
      assert page_xml.barcode == "some barcode"
      assert page_xml.orig_xml == "some orig_xml"
      assert page_xml.s3_key == "some s3_key"
    end

    test "create_page_xml/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Caselaw.create_page_xml(@invalid_attrs)
    end

    test "update_page_xml/2 with valid data updates the page_xml" do
      page_xml = page_xml_fixture()
      assert {:ok, page_xml} = Caselaw.update_page_xml(page_xml, @update_attrs)
      assert %PageXML{} = page_xml
      assert page_xml.barcode == "some updated barcode"
      assert page_xml.orig_xml == "some updated orig_xml"
      assert page_xml.s3_key == "some updated s3_key"
    end

    test "update_page_xml/2 with invalid data returns error changeset" do
      page_xml = page_xml_fixture()
      assert {:error, %Ecto.Changeset{}} = Caselaw.update_page_xml(page_xml, @invalid_attrs)
      assert page_xml == Caselaw.get_page_xml!(page_xml.id)
    end

    test "delete_page_xml/1 deletes the page_xml" do
      page_xml = page_xml_fixture()
      assert {:ok, %PageXML{}} = Caselaw.delete_page_xml(page_xml)
      assert_raise Ecto.NoResultsError, fn -> Caselaw.get_page_xml!(page_xml.id) end
    end

    test "change_page_xml/1 returns a page_xml changeset" do
      page_xml = page_xml_fixture()
      assert %Ecto.Changeset{} = Caselaw.change_page_xml(page_xml)
    end
  end

  describe "capdb_casexml" do
    alias Caprice.Caselaw.CaseXML

    @valid_attrs %{case_id: "some case_id", orig_xml: "some orig_xml", s3_key: "some s3_key"}
    @update_attrs %{case_id: "some updated case_id", orig_xml: "some updated orig_xml", s3_key: "some updated s3_key"}
    @invalid_attrs %{case_id: nil, orig_xml: nil, s3_key: nil}

    def case_xml_fixture(attrs \\ %{}) do
      {:ok, case_xml} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Caselaw.create_case_xml()

      case_xml
    end

    test "list_capdb_casexml/0 returns all capdb_casexml" do
      case_xml = case_xml_fixture()
      assert Caselaw.list_capdb_casexml() == [case_xml]
    end

    test "get_case_xml!/1 returns the case_xml with given id" do
      case_xml = case_xml_fixture()
      assert Caselaw.get_case_xml!(case_xml.id) == case_xml
    end

    test "create_case_xml/1 with valid data creates a case_xml" do
      assert {:ok, %CaseXML{} = case_xml} = Caselaw.create_case_xml(@valid_attrs)
      assert case_xml.case_id == "some case_id"
      assert case_xml.orig_xml == "some orig_xml"
      assert case_xml.s3_key == "some s3_key"
    end

    test "create_case_xml/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Caselaw.create_case_xml(@invalid_attrs)
    end

    test "update_case_xml/2 with valid data updates the case_xml" do
      case_xml = case_xml_fixture()
      assert {:ok, case_xml} = Caselaw.update_case_xml(case_xml, @update_attrs)
      assert %CaseXML{} = case_xml
      assert case_xml.case_id == "some updated case_id"
      assert case_xml.orig_xml == "some updated orig_xml"
      assert case_xml.s3_key == "some updated s3_key"
    end

    test "update_case_xml/2 with invalid data returns error changeset" do
      case_xml = case_xml_fixture()
      assert {:error, %Ecto.Changeset{}} = Caselaw.update_case_xml(case_xml, @invalid_attrs)
      assert case_xml == Caselaw.get_case_xml!(case_xml.id)
    end

    test "delete_case_xml/1 deletes the case_xml" do
      case_xml = case_xml_fixture()
      assert {:ok, %CaseXML{}} = Caselaw.delete_case_xml(case_xml)
      assert_raise Ecto.NoResultsError, fn -> Caselaw.get_case_xml!(case_xml.id) end
    end

    test "change_case_xml/1 returns a case_xml changeset" do
      case_xml = case_xml_fixture()
      assert %Ecto.Changeset{} = Caselaw.change_case_xml(case_xml)
    end
  end
end
