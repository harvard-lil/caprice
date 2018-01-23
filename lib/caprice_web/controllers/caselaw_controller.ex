defmodule CapriceWeb.CaselawController do
  use CapriceWeb, :controller
  import Caprice.Caselaw

  def case_xml(conn,  %{"barcode" => barcode, "case_no" => case_no}) do
  	case_id = barcode <> "_" <> String.pad_leading(case_no, 4, "0")
    case_record = get_case_xml_by_caseid(case_id)
    if case_record == nil do
      conn
      |> send_resp(404, "case not found")
      |> halt()
    end
    conn
    |> put_resp_header("content-type", "application/xml")
    |> send_resp(200, case_record.orig_xml)
  end

  def volume_xml(conn,  %{"barcode" => barcode}) do
    volume_record = get_volume_xml_by_barcode!(barcode)
    if volume_record == nil do
      conn
      |> send_resp(404, "volume not found")
      |> halt()
    end
    conn
    |> put_resp_header("content-type", "application/xml")
    |> send_resp(200, volume_record.orig_xml)
  end

  def page_xml(conn,  %{"barcode" => barcode, "leaf_no" => leaf_no, "page_side" => page_side}) do
    barcode = barcode <> "_" <> String.pad_leading(leaf_no, 5, "0") <> "_" <> page_side
    page_record = get_page_xml_by_barcode!(barcode)
    if page_record == nil do
      conn
      |> send_resp(404, "page not found")
      |> halt()
    end
    conn
    |> put_resp_header("content-type", "application/xml")
    |> send_resp(200, page_record.orig_xml)
  end

  def page_html(conn,  %{"barcode" => barcode, "leaf_no" => leaf_no, "page_side" => page_side}) do
    barcode = barcode <> "_" <> String.pad_leading(leaf_no, 5, "0") <> "_" <> page_side
    page_record = get_page_xml_by_barcode!(barcode)
    if page_record == nil do
      conn
      |> send_resp(404, "page not found")
      |> halt()
    end
    conn
    |> put_resp_header("content-type", "application/xml")
    |> send_resp(200, page_record.orig_xml)
  end



  def case_pages(conn,  %{"barcode" => barcode, "case_no" => case_no}) do
    case_id = barcode <> "_" <> String.pad_leading(case_no, 4, "0")
    case_record = get_case_with_pages_by_caseid!(case_id)

    if case_record == nil do
      conn
      |> send_resp(404, "case not found")
      |> halt()
    end
    
    case_pages = get_json_page_or_vol_map(case_record.capdb_pagexmls)
    conn
    |> put_resp_header("content-type", "application/json")
    |> json(case_pages)
  end

  def volume_list(conn, _params) do
    volume_list = get_json_page_or_vol_map(list_capdb_volumexml())
    conn
    |> put_resp_header("content-type", "application/json")
    |> json(volume_list)
  end

  def volume_contents(conn, %{"barcode" => barcode}) do
    volume_xml = get_volume_xml_with_associations_by_barcode!(barcode)
    cases = IO.inspect(get_json_case_map(volume_xml.capdb_casexmls))
    pages = get_json_page_or_vol_map(volume_xml.capdb_pagexmls)

    conn
    |> put_resp_header("content-type", "application/json")
    |> json(%{cases: cases, pages: pages})
  end

  def get_json_page_or_vol_map(pages_or_volumes) do
    Enum.map(pages_or_volumes, &(%{ id: &1.id, barcode: &1.barcode, timestamp: &1.inserted_at}))
  end

  def get_json_case_map(cases) do
    Enum.map(cases, &(%{ id: &1.id, case_id: &1.case_id, timestamp: &1.inserted_at}))
  end
end
