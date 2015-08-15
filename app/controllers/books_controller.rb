require 'prawn'
include ActionView::Helpers::TextHelper

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
        child_count = relationship.children.count
        if child_count > 0
          if root.relationships.count > 1
            generation_text << "<b>Children of #{root.name} (0) and #{(index + 1).to_i.ordinalise} #{(root.male)? 'wife' : 'husband'} #{partner.name}:</b>\n\n"
          else
            generation_text << "<b>Children of #{root.name} (0) and #{partner.name}:</b>\n\n"
          end
          relationship.children.order("kbns ASC").each do |child|
            generation_text << print_person(child) + "\n"
          end
        end
      end
    end
    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### THIRD GENERATION #####
    generation_text = print_generation(root.children.order("kbns ASC"), '', 3)

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
            child_count = relationship.children.count
            if child_count > 0
              if person.relationships.count > 1
                text << "<b>Children of #{person.name} (#{person.kbn.first}) and #{(index + 1).ordinalise} #{(person.male)? 'wife' : 'husband'} #{partner.name}:</b>\n\n"
              else
                text << "<b>Children of #{person.name} (#{person.kbn.first}) and #{partner.name}:</b>\n\n"
              end
              relationship.children.order("kbns ASC").each do |child|
                text << print_person(child) + "\n"
              end
            end
          end
        end
        children = children + Person.where("kbns @> '{#{person.first_generation.join(',')}}'").order("kbns ASC")
      end
      text = print_generation(children, text, (generation + 1)) if generation < 11
      text
    end

    def print_person(person)
      person_text = ''
      person_text << "#{person.kbns.first}         #{person.name}, #{date_text(person, true, nil)}."
      person.relationships.each_with_index do |relationship, index|
        child_count = relationship.children.count
        partner = Person.where(id: relationship.partner_ids).where.not(id: person.id).first
        marriage_date = relationship.marriage_day
        divorced = (relationship.divorce_day.nil?)? false : true
        if index == 0
          person_text << "  Married #{(person.partners.count > 1)? (index + 1).ordinalise + ' ' : ''}#{(marriage_date.nil?)? '' : "in #{marriage_date} "}to:\n#{(divorced)? '**' : '*'}#{partner.name}, #{date_text(partner, false, relationship.divorce_day)}"
        else
          person_text << "\n#{(divorced)? '**' : '*'}#{partner.name} married #{(person.male)? 'him' : 'her'} #{(marriage_date.nil?)? '' : "in #{marriage_date}"}; #{date_text(partner, false, relationship.divorce_day)}"
        end
        person_text << "; #{pluralize(child_count, 'child')} by this union." if person.partners.count > 1
        person_text << "\n" unless index == 0
      end

      count = person.descendents.count
      if count > 0
        person_text << "\n#{count} Total #{'descendant'.pluralize(count)}"
        count = person.first_generation.count
        if count > 0
          person_text << "\n#{pluralize(count, 'child').titleize}"
          count = person.second_generation.count
          if count > 0
            person_text << "\n#{pluralize(count, 'grandchild').titleize}"
            count = person.third_generation.count
            if count > 0
              person_text << "\n#{count} Great #{'grandchild'.pluralize(count)}"
              count = person.fourth_generation.count
              if count > 0
                person_text << "\n#{count} Great great #{'grandchild'.pluralize(count)}"
                count = person.fifth_generation.count
                if count > 0
                  person_text << "\n#{count} Great great great #{'grandchild'.pluralize(count)}"
                  count = person.sixth_generation.count
                  if count > 0
                    person_text << "\n#{count} Great great great great #{'grandchild'.pluralize(count)}"
                    count = person.seventh_generation.count
                    if count > 0
                      person_text << "\n#{count} Great great great great great #{'grandchild'.pluralize(count)}"
                      count = person.eighth_generation.count
                      if count > 0
                        person_text << "\n#{count} Great great great great great great #{'grandchild'.pluralize(count)}"
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

    def date_text(person, show_location, divorce_day)
      date_text = ""
      if person.birth_day.present?
        born_text = "born #{person.birth_day}"
        if show_location && person.birth_place.present?
          born_text += ", " if born_text != "born "
          born_text += "#{person.birth_place}"
        end
      end
      if person.death_day.present?
        death_text = "died #{person.death_day}"
        if show_location && person.death_place.present?
          death_text += ", " if death_text != "died "
          death_text += "buried #{person.death_place}"
        end
      end
      date_text += born_text if born_text.present?
      date_text += "; #{death_text}" if death_text.present?
      date_text += "; #{divorce_day}" if divorce_day.present?
      date_text
    end
end
