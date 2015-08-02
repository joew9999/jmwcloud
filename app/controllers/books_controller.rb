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
    root = Person.find_by_kbn('0')
    pdf.text "<b>FIRST GENERATION IN TEXAS</b>", align: :center, inline_format: true
    pdf.move_down 13
    generation_text = ''
    generation_text << print_person(root) + "\n"
    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### SECOND GENERATION #####
    pdf.text "<b>SECOND GENERATION IN TEXAS</b>", align: :center, inline_format: true
    pdf.move_down 13
    generation_text = ''
    root.relationships.each_with_index do |relationship, index|
      partner = Person.where(id: relationship.partner_ids).where.not(id: root.id).first rescue nil
      unless partner.nil?
        if root.relationships.count > 1
          generation_text << "<b>Children of #{root.name} (#{root.kbn}) and #{(index + 1).to_i.ordinalise} #{(root.male)? 'wife' : 'husband'} #{partner.name}:</b>\n\n"
        else
          generation_text << "<b>Children of #{root.name} (#{root.kbn}) and #{partner.name}:</b>\n\n"
        end
        relationship.children.each do |child|
          generation_text << print_person(child) + "\n"
        end
      end
    end
    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### THIRD GENERATION #####
    generation_text = print_generation(root.children, '', 3)

    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end

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

    def print_generation(people, text, generation)
      children = []
      text << "<b>#{generation.ordinalise.upcase} GENERATION IN TEXAS</b>\n\n"
      people.each do |person|
        person.relationships.each_with_index do |relationship, index|
          partner = Person.where(id: relationship.partner_ids).where.not(id: person.id).first rescue nil
          unless partner.nil?
            if person.relationships.count > 1
              text << "<b>Children of #{person.name} (#{person.kbn}) and #{(index + 1).ordinalise} #{(person.male)? 'wife' : 'husband'} #{partner.name}:</b>\n\n"
            else
              text << "<b>Children of #{person.name} (#{person.kbn}) and #{partner.name}:</b>\n\n"
            end
            relationship.children.order("kbn ASC").each do |child|
              text << print_person(child) + "\n"
            end
          end
        end
        children = children + person.greatgrandchildren(1)
      end
      text = print_generation(children, text, (generation + 1)) if generation < 11
      text
    end

    def print_person(person)
      person_text = ''
      person_text << "#{person.kbn}         #{person.name}#{date_text(person, true)}."
      person.relationships.each_with_index do |relationship, index|
        child_count = relationship.children.count
        if child_count > 0
          partner = Person.where(id: relationship.partner_ids).where.not(id: person.id).first
          marriage_date = relationship.marriage_day
          divorced = (relationship.divorce_day.nil?)? false : true
          if index == 0
            person_text << " Married #{(person.partners.count > 1)? (index + 1).ordinalise + ' ' : ''}#{(marriage_date.nil?)? '' : "in #{marriage_date} "}to:\n#{(divorced)? '**' : '*'}#{partner.name}, #{date_text(partner, false)}"
          else
            person_text << "\n#{(divorced)? '**' : '*'}#{partner.name} married #{(person.male)? 'him' : 'her'} #{(marriage_date.nil?)? '' : "in #{marriage_date}"}; #{date_text(partner, false)}"
          end
          person_text << "; #{child_count} #{(child_count > 1)? 'children' : 'child'} by this union." if person.partners.count > 1
          person_text << "\n" unless index == 0
        end
      end

      if person.descendents.count > 0
        person_text << "\n#{person.descendents.count} Total descendants"
        if person.greatgrandchildren(1).count > 0
          person_text << "\n#{person.greatgrandchildren(1).count} Children"
          if person.greatgrandchildren(2).count > 0
            person_text << "\n#{person.greatgrandchildren(2).count} Grandchildren"
            if person.greatgrandchildren(3).count > 0
              person_text << "\n#{person.greatgrandchildren(3).count} Great grandchildren"
              if person.greatgrandchildren(4).count > 0
                person_text << "\n#{person.greatgrandchildren(4).count} Great great grandchildren"
                if person.greatgrandchildren(5).count > 0
                  person_text << "\n#{person.greatgrandchildren(5).count} Great great great grandchildren"
                  if person.greatgrandchildren(6).count > 0
                    person_text << "\n#{person.greatgrandchildren(6).count} Great great great great grandchildren"
                    if person.greatgrandchildren(7).count > 0
                      person_text << "\n#{person.greatgrandchildren(7).count} Great great great great great grandchildren"
                      if person.greatgrandchildren(8).count > 0
                        person_text << "\n#{person.greatgrandchildren(8).count} Great great great great great great grandchildren"
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

    def date_text(person, show_location)
      date_text = ""
      if !person.birth_day.blank?
        born_text = "born #{person.birth_day}"
        if show_location
          born_text += ", " if born_text != "born "
          born_text += "in #{person.birth_place}" if !person.birth_place.blank?
        end
      end
      if !person.death_day.blank?
        death_text = "died #{person.death_day}"
        if show_location
          death_text += ", " if death_text != "died "
          death_text += "buried #{person.death_place}" if !person.death_place.blank?
        end
      end
      date_text += born_text unless born_text.nil?
      date_text += "; #{death_text}" unless death_text.nil?
      date_text = ", #{date_text}" if date_text != ''
      date_text
    end
end
