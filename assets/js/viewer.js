/*
 * This file contains the javascript for the case viewer app. It should probably be organized better.
 */



// Namespaces. DOMParser doesn't deal with shorthand namespaces, only full URLs
const ns_case = "http://nrs.harvard.edu/urn-3:HLS.Libr.US_Case_Law.Schema.Case:v1"
const ns_casebody = "http://nrs.harvard.edu/urn-3:HLS.Libr.US_Case_Law.Schema.Case_Body:v1"
const ns_mets = "http://www.loc.gov/METS/"
const ns_alto = "http://www.loc.gov/standards/alto/ns-v3#"

/* 
 * I made this a global (to this file) because I'm lazy. It stores the alto
 * elements that belong to the case, which are gleaned from the casebody. This
 * is useful because otherwise, the viewer would potentially display the tail of
 * the previous case, on the first page, and the beginning * of the next case on
 * the last page.
 */  
let case_elements = []

// this const is the box which the chat messages go into. It's written in 
// templates/layouts/app.html.eex
const chat_box = document.getElementById('bottom_chatbox');

// these 2 functions will start and stop chat. Right now they show/hid the box
function destroy_chat() {
  chat_box.style.display = 'none';
	console.log("stop chat function");
}

function initialize_chat(room_name) {
  // TODO: make chat channels and make JS hook up to it
  chat_box.style.display = 'block';
	console.log("initialize chat function");
}

// Give the chat toggle button functionality
let chatButton = document.querySelector('#chat_button')
if (chatButton) {
	chatButton.addEventListener('click', function (e) {
		let room_name = "lobby"
		if (chat_box.style.display === 'none') {
			initialize_chat(room_name);
		} else {
			destroy_chat();
		}	
	}, false);
}

/*
 * This SPA-style thing basically uses values in the #hash as parameters. In this
 * code we listen for changes in the hash, and then run the loadContent function
 */

window.onhashchange = function () {
  loadContent();
};

/*
 * loadContent() essentially acts as a router. 
 * If the hash is missing, we get our volumes
 * If the hash is a volume barcode, we get a case list
 * If the hash is a case "barcode," we display the case
 */

function loadContent() {
  if(window.location.hash) {
    if (window.location.hash.includes("_")) {
      get_case(window.location.hash.substr(1));
    } else {
      get_case_list(window.location.hash.substr(1));
    }
  } else {
    get_volume_list();
  }
}

/*
 * This function fetches the case_xml and triggers the process_case_xml 
 * function, then fetches the list of pages that belong to the case, 
 * creates the page section elements and then fetches the page ALTO XML
 * and triggers process_case_body which populates the page elements.
 */

function get_case(case_id) {
  // /xml/barcode/casenumber returns case_xml
  let case_parts = case_id.split("_")
  fetch("/xml/" + case_parts[0] + "/" + case_parts[1]).then(response => response.text())
     .then(case_xml => {
        process_case_xml(case_xml);

        // /metadata/barcode/casenumber returns a JSON object of 
        // ALTO pages in the case
        return fetch("/metadata/" + case_parts[0] + "/" + case_parts[1]);
     })
     .then(response => response.json())
     .then(case_pages => {
        /* Welcome to Spaghettiville. For each of the case pages, we start
         * by calculating some of the page dimensions for page placement.
         */
        let top_pixel_offset = document.getElementById("casemetadata").getBoundingClientRect().bottom + 50
        let container_width = document.getElementById("case_body").getBoundingClientRect().width
        let page_width = Math.round(container_width * 0.9)
        let left_pixel_offset = Math.round(document.getElementById("case_body").getBoundingClientRect().left + (container_width * 0.05))

        //Here we loop through each case page in order
        let case_body_element = document.getElementById("case_body")
        case_pages.forEach(function(case_page) {
          /* Create the pages, set the ID to the .tif file name so 
           * process_case_body() can find them and fill them in.
           */

          //actually fetch the page
          fetch("/xml/" + case_page.barcode.replace(/_/g, "/"))
          .then(response => { 
              let page_element = document.createElement("section");
              page_element.id = case_page.barcode + ".tif"
              page_element.style.zIndex = "-1"
              page_element.classList.add('case_page')
              page_element.appendChild(document.createTextNode(case_page.barcode))
              case_body_element.appendChild(page_element)
              console.log("created " + case_page.barcode + ".tif")

              return response.text()
            })
          .then(case_page_response => {
            // process_case_body() returns the top_pixel_offset because the 
            // value depends on the height page it just created 
            top_pixel_offset = process_case_body(case_page_response, top_pixel_offset, page_width, left_pixel_offset)
          })
        })

     })
     .catch(error => {
        setStatus(error);
     });
}


function get_case_list(barcode) {
  setStatus("loading");
  fetch("/metadata/" + barcode).then(response => response.json())
     .then(case_list => {
          populate_from_json(case_list.cases);
     })
     .catch(error => {
        setStatus(error);
     });
}

function get_volume_list() {
  setStatus("loading");
	fetch("/metadata").then(response => response.json())
     .then(volume_list => {
          populate_from_json(volume_list);
     })
     .catch(error => {
        setStatus(error);
     });
}

function populate_from_json(json_object) {
    json_object.forEach(function(element) {

      var identifier = ''
      if (element.hasOwnProperty("barcode")) {  
        identifier = element.barcode
      } else if (element.hasOwnProperty("case_id")) {
        identifier = element.case_id
      }
      let li = document.createElement("li");
      let a = document.createElement('a');
      a.appendChild(document.createTextNode(identifier));
      a.title = "link to view " + identifier;
      a.href = "#" + identifier;
      li.appendChild(a);
      json_list.appendChild(li);

    })
    setStatus("loaded");
}

function process_case_body(page_xml, top_pixel_offset, page_width, left_pixel_offset) {
  let case_body_element = document.getElementById("case_body")
  let oParser = new DOMParser();
  let oDOM = oParser.parseFromString(page_xml, "text/xml");
  let page = oDOM.getElementsByTagNameNS(ns_alto, "Page")[0]
  let alto_height = page.getAttribute("HEIGHT")
  let alto_width = page.getAttribute("WIDTH")
  let page_height = Math.round((alto_height/alto_width) * page_width)
  let size_difference = page_width / alto_width 
  let print_space = oDOM.getElementsByTagNameNS(ns_alto, "PrintSpace")[0]





  let text_style_elements = oDOM.getElementsByTagNameNS(ns_alto, "TextStyle")
  let styles = {};
  for (let text_style_element of text_style_elements) {
    styles[text_style_element.getAttribute("ID")] = {};
    if (text_style_element.hasAttribute("FONTFAMILY"))
      styles[text_style_element.getAttribute("ID")].family = text_style_element.getAttribute("FONTFAMILY")
    if (text_style_element.hasAttribute("FONTSIZE"))
      styles[text_style_element.getAttribute("ID")].size = text_style_element.getAttribute("FONTSIZE")
    if (text_style_element.hasAttribute("FONTTYPE"))
      styles[text_style_element.getAttribute("ID")].type = text_style_element.getAttribute("FONTTYPE")
    if (text_style_element.hasAttribute("FONTWIDTH"))
      styles[text_style_element.getAttribute("ID")].width = text_style_element.getAttribute("FONTWIDTH")
    if (text_style_element.hasAttribute("FONTSTYLE"))
      styles[text_style_element.getAttribute("ID")].style = text_style_element.getAttribute("FONTSTYLE").split(" ");
  }

  let structure_tag_elements = oDOM.getElementsByTagNameNS(ns_alto, "StructureTag")
  let tags = {};
  for (let structure_tag of structure_tag_elements) {
    tags[structure_tag.getAttribute("ID")] = structure_tag.getAttribute("LABEL");
  }


  let file_name = oDOM.getElementsByTagNameNS(ns_alto, "fileName")[0]
  console.log("looking for " + file_name.textContent)
  let page_element = document.getElementById(file_name.textContent);

  for (var text_block of print_space.childNodes) {
    if (!text_block.tagName)
      continue;
    let tagref = text_block.getAttribute("TAGREFS");
    if (!case_elements.includes(tagref))
      continue;
    for (var text_line of text_block.childNodes) {
      if (text_line.nodeType === 3)
        continue
      let line_top = text_line.getAttribute("VPOS")
      for (var string of text_line.childNodes) {
        if (string.tagName == "String") {
          let string_height = string.getAttribute("HEIGHT")
          let string_width = string.getAttribute("WIDTH")
          let string_left = string.getAttribute("HPOS")
          let string_top = string.getAttribute("VPOS")
          let string_style = styles[string.getAttribute("STYLEREFS")]


          let real_left = (string_left * size_difference) 
          let real_top = (string_top * size_difference) 
          let real_width = string_width * size_difference
          let real_height = string_height * size_difference

          let new_string_element = document.createElement("span");
          new_string_element.appendChild(document.createTextNode(string.getAttribute("CONTENT")))

          if (string_style.hasOwnProperty("style")) {
            if (string_style.style.includes("smallcaps"))
              new_string_element.style.fontVariant = "small-caps" 
            
            if (string_style.style.includes("bold"))
              new_string_element.style.fontWeight = "bold"

            if (string_style.style.includes("italics"))
              new_string_element.style.fontStyle = "italic" 
          }

          new_string_element.style.position = "absolute";
          new_string_element.style.top = line_top * size_difference + "px";
          new_string_element.style.left = string_left * size_difference + "px";
          new_string_element.style.fontSize = string_style['size'] * size_difference+ "mm";
          new_string_element.style.fontFamily = string_style['family'];
          new_string_element.style.width = real_width * size_difference+ "mm";
          new_string_element.style.height = real_height * size_difference+ "mm";
          page_element.appendChild(new_string_element)
        } else {
          page_element.appendChild(document.createTextNode(" "))
        }

      }
    }

    page_element.style.position = "absolute";
    page_element.style.width = page_width + "px";
    page_element.style.height = page_height + "px";
    page_element.style.top = top_pixel_offset + "px";
    page_element.style.left = left_pixel_offset + "px";

  }

  return top_pixel_offset + page_height + 20
}

function process_case_xml(case_xml) {
  document.getElementById("case_display").style.display = 'block';
  let oParser = new DOMParser();
  let oDOM = oParser.parseFromString(case_xml, "text/xml");

  let area_tags = oDOM.getElementsByTagNameNS(ns_mets, "area")
  for (var i = 0; i < area_tags.length; i++) {
      if (area_tags[i].getAttribute("FILEID").startsWith("casebody")) {
        case_elements.push(area_tags[i].getAttribute("BEGIN"));
      }
  }

  /*
  * This section displays headers/metadata
  */
  let court_name_value = oDOM.getElementsByTagNameNS(ns_case, "court")[0].textContent;
  let case_name_value = oDOM.getElementsByTagNameNS(ns_case, "name")[0].textContent;
  let case_abbreviation_value = oDOM.getElementsByTagNameNS(ns_case, "name")[0].getAttribute("abbreviation");
  let docket_number_value = oDOM.getElementsByTagNameNS(ns_case, "docketnumber")[0].textContent;
  let decision_date_value = oDOM.getElementsByTagNameNS(ns_case, "decisiondate")[0].textContent;
  let citation_list = oDOM.getElementsByTagNameNS(ns_case, "citation")
  
  let court_name_element = document.getElementById("court_name")
  let case_abbreviation_element = document.getElementById("case_abbreviation")
  let case_name_element = document.getElementById("case_name")
  let docket_number_element = document.getElementById("docket_number")
  let decision_date_element = document.getElementById("decision_date")
  let citation_list_element = document.getElementById("citation_list")

  case_name_element.innerHTML = case_name_value
  court_name_element.innerHTML = court_name_value
  case_abbreviation_element.innerHTML = case_abbreviation_value
  docket_number_element.innerHTML = "Docket: " + docket_number_value
  decision_date_element.innerHTML = decision_date_value

  for (var i = citation_list.length - 1; i >= 0; i--) {
    let citation_text = jsUcfirst(citation_list[i].getAttribute("category")) + " " + jsUcfirst(citation_list[i].getAttribute("type")) + " Citation: " + citation_list[i].textContent
    let li = document.createElement("li");
    li.appendChild(document.createTextNode(citation_text));
    citation_list_element.appendChild(li);
  }
}


/*
 * This just clears out existing data and preps it for new content
 */
function setStatus(status) {
  if (status == "loading") {
    destroy_chat()

    // clear out any json results we've got
    let json_list = document.getElementById("json_list");
    while (json_list.firstChild) {
      json_list.removeChild(json_list.firstChild);
    }

    // clear out the citation list
    let citation_list_element = document.getElementById("citation_list");
    while (citation_list_element.firstChild) {
      citation_list_element.removeChild(citation_list_element.firstChild);
    }
    // zero out the content in the case display area
    document.getElementById("court_name").innerHTML = "";
    document.getElementById("case_abbreviation").innerHTML = "";
    document.getElementById("case_name").innerHTML = "";
    document.getElementById("docket_number").innerHTML = "";
    document.getElementById("decision_date").innerHTML = "";

    //remove the case_body elements
    let case_body_element = document.getElementById("case_body");
    while (case_body_element.firstChild) {
      case_body_element.removeChild(case_body_element.firstChild);
    }

    //hide the case display altogether. We'll enable it if we need to
    document.getElementById("case_display").style.display = 'none';
  }

  console.log(status);
}

// converts the first character in a string to uppercase
function jsUcfirst(string) 
{
    return string.charAt(0).toUpperCase() + string.slice(1);
}

loadContent()