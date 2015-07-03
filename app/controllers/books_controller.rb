require 'prawn'

class BooksController < AuthenticatedController
  def index
  end

  def create
    pdf = Prawn::Document.new
    setup_font(pdf)
    pdf.font_size 24

    pdf.move_down 250
    pdf.text "<b>THE KOTHMANNS OF TEXAS</b>", align: :center, inline_format: true
    pdf.text "1845-2015", align: :center
    pdf.move_down 18
    pdf.text "FAMILY REGISTER", align: :center
    pdf.move_down 27
    pdf.font_size 14
    pdf.text "STAMMVATER: Hennig Heinrich Kothmann", align: :center
    pdf.move_down 15
    pdf.text "Hennig Heinrich Kothmann and Ilse Dorothee Marwede, both born in Wedelheine, Germany (dates not available).", align: :center
    pdf.start_new_page

    setup_font(pdf)
##### FIRST GENERATION #####
    root = Person.find_by_kbn(0)
    pdf.text "<b>FIRST GENERATION IN TEXAS</b>", align: :center, inline_format: true
    pdf.move_down 13
    generation_text = ''
    generation_text << print_person(pdf, root) + "\n"
    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### SECOND GENERATION #####
    pdf.text "<b>SECOND GENERATION IN TEXAS</b>", align: :center, inline_format: true
    pdf.move_down 13
    generation_text = ''
    root.relationship_people.where(type: 'RelationshipPartner').each_with_index do |relationship_person, index|
      partner = relationship_person.relationship.relationship_people.where(type: 'RelationshipPartner').where("person_id != #{root.id}").first.person rescue nil
      unless partner.nil?
        generation_text << "<b>Children of #{root.name} and #{(index + 1).to_i.ordinalise} #{(root.male)? 'wife' : 'husband'} #{partner.name}:</b>\n\n"
        relationship_person.relationship.relationship_people.where(type: 'RelationshipChild').each do |relationship_child|
          generation_text << print_person(pdf, relationship_child.person) + "\n"
        end
      end
    end
    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### THIRD GENERATION #####
    pdf.text "<b>THIRD GENERATION IN TEXAS</b>", align: :center, inline_format: true
    pdf.move_down 13
    generation_text = ''
    root.children.each do |root_child|
      root_child.relationship_people.where(type: 'RelationshipPartner').each_with_index do |relationship_person, index|
        partner = relationship_person.relationship.relationship_people.where(type: 'RelationshipPartner').where("person_id != #{root.id}").first.person rescue nil
        unless partner.nil?
          generation_text << "<b>Children of #{root_child.name} and #{(index + 1).ordinalise} #{(root_child.male)? 'wife' : 'husband'} #{partner.name}:</b>\n\n"
          relationship_person.relationship.relationship_people.where(type: 'RelationshipChild').each do |relationship_child|
            generation_text << print_person(pdf, relationship_child.person) + "\n"
          end
        end
      end
    end
    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### PRINT #####
    pdf.number_pages "<page>", { at: [pdf.bounds.right - 50, 0], width: 50, align: :right, start_count_at: 1 }
    pdf.render_file "app/assets/exports/pdfs/family_registry.pdf"
  end

  private
    def setup_font(pdf)
      pdf.font_families["Palatino"] = {
        normal: {file: Rails.root + "app/assets/fonts/Palatino.ttf", font: "Palatino" },
        italic: {file: Rails.root + "app/assets/fonts/Palatino-Italic.ttf", font: "Palatino-Italic" },
        bold: {file: Rails.root + "app/assets/fonts/Palatino-Bold.ttf", font: "Palatino-Bold" },
        bold_italic: {file: Rails.root + "app/assets/fonts/Palatino-BoldItalic.ttf", font: "Palatino-BoldItalic" }
      }
      pdf.font("Palatino")
      pdf.font_size 10
    end

    def print_person(pdf, person)
      person_text = ''
      person_text << "#{person.book_numbers.first.kbn}         #{person.name}#{date_text(person)}."
      person.relationship_people.where(type: 'RelationshipPartner').each_with_index do |relationship_person, index|
        relationship = relationship_person.relationship
        partner = relationship.relationship_people.where(type: 'RelationshipPartner').where("person_id != #{person.id}").first.person
        marriage_date = relationship.events.first.time rescue nil
        divorced = relationship.events.count > 1 rescue false
        child_count = relationship.relationship_people.where(type: 'RelationshipChild').count
        if index == 0
          person_text << " Married #{(person.partners.count > 1)? (index + 1).ordinalise + ' ' : ''}#{(marriage_date.nil?)? '' : "in #{marriage_date} "}to:\n#{(divorced)? '**' : '*'}#{partner.name}, #{date_text(partner)}"
        else
          person_text << "\n#{(divorced)? '**' : '*'}#{partner.name} married #{(person.male)? 'him' : 'her'} #{(marriage_date.nil?)? '' : "in #{marriage_date}"}; #{date_text(partner)}"
        end
        person_text << "; #{child_count} #{(child_count > 1)? 'children' : 'child'} by this union." if person.partners.count > 1
        person_text << "\n" unless index == 0
      end

      if person.descendents > 0
        person_text << "\n#{person.descendents} Total descendants"
        if person.children.count > 0
          person_text << "\n#{person.children.count} Children"
          if person.grandchildren > 0
            person_text << "\n#{person.grandchildren} Grandchildren"
            if person.greatgrandchildren(0, 1) > 0
              person_text << "\n#{person.greatgrandchildren(0, 1)} Great grandchildren"
              if person.greatgrandchildren(0, 2) > 0
                person_text << "\n#{person.greatgrandchildren(0, 2)} Great great grandchildren"
                if person.greatgrandchildren(0, 3) > 0
                  person_text << "\n#{person.greatgrandchildren(0, 3)} Great great great grandchildren"
                  if person.greatgrandchildren(0, 4) > 0
                    person_text << "\n#{person.greatgrandchildren(0, 4)} Great great great great grandchildren"
                    if person.greatgrandchildren(0, 5) > 0
                      person_text << "\n#{person.greatgrandchildren(0, 5)} Great great great great great grandchildren"
                      if person.greatgrandchildren(0, 6) > 0
                        person_text << "\n#{person.greatgrandchildren(0, 6)} Great great great great great great grandchildren"
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
#       page_lookup[person.kbn] = pdf.page_count
#       page_lookup
      person_text + "\n"
    end

    def date_text(person)
      birth = person.events.where(type: 'Birth').first
      death = person.events.where(type: 'Death').first
      date_text = ""
      unless birth.nil?
        born_text = "born #{birth.time.to_s}"
        born_text += ", " if born_text != "born "
        born_text += "in #{birth.location}" if birth.location != ''
      end
      unless death.nil?
        death_text = "died #{death.time.to_s}"
        death_text += ", " if death_text != "died "
        death_text += "at #{death.location}" if death.location != ''
      end
      date_text += born_text unless born_text.nil?
      date_text += "; #{death_text}" unless death_text.nil?
      date_text = ", #{date_text}" if date_text != ''
      date_text
    end
end
