require 'prawn'
include ActionView::Helpers::TextHelper

class BooksController < AuthenticatedController
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

##### FIRST GENERATION #####
    setup_font(pdf)

    pdf.move_down 250
    pdf.text "<b>FIRST GENERATION IN TEXAS</b>", align: :center, inline_format: true
    pdf.start_new_page

    root = Person.find_by_kbn('0')
    generation_text = ''
    generation_text << print_person(root, nil) + "\n"
    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### SECOND GENERATION #####

    pdf.move_down 250
    pdf.text "<b>SECOND GENERATION IN TEXAS</b>", align: :center, inline_format: true
    pdf.start_new_page

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
            generation_text << print_person(child, '0') + "\n"
          end
        end
      end
    end
    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### THIRD GENERATION #####

    children = root.children.order("kbns ASC")
    generation_text = print_generation(children)

    pdf.move_down 250
    pdf.text "<b>THIRD GENERATION IN TEXAS</b>", align: :center, inline_format: true
    pdf.start_new_page

    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### FOURTH GENERATION #####

    children = Person.children(children)
    generation_text = print_generation(children)

    pdf.move_down 250
    pdf.text "<b>FOURTH GENERATION IN TEXAS</b>", align: :center, inline_format: true
    pdf.start_new_page

    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### FIFTH GENERATION #####

    children = Person.children(children)
    generation_text = print_generation(children)

    pdf.move_down 250
    pdf.text "<b>FIFTH GENERATION IN TEXAS</b>", align: :center, inline_format: true
    pdf.start_new_page

    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### SIXTH GENERATION #####

    children = Person.children(children)
    generation_text = print_generation(children)

    pdf.move_down 250
    pdf.text "<b>SIXTH GENERATION IN TEXAS</b>", align: :center, inline_format: true
    pdf.start_new_page

    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### SEVENTH GENERATION #####

    children = Person.children(children)
    generation_text = print_generation(children)

    pdf.move_down 250
    pdf.text "<b>SEVENTH GENERATION IN TEXAS</b>", align: :center, inline_format: true
    pdf.start_new_page

    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### EIGHTH GENERATION #####

    children = Person.children(children)
    generation_text = print_generation(children)

    pdf.move_down 250
    pdf.text "<b>EIGHTH GENERATION IN TEXAS</b>", align: :center, inline_format: true
    pdf.start_new_page

    pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
      pdf.text generation_text, inline_format: true
    end
    pdf.start_new_page

##### NINTH GENERATION #####

    children = Person.children(children)
    if children.any?
      generation_text = print_generation(children)

      pdf.move_down 250
      pdf.text "<b>NINTH GENERATION IN TEXAS</b>", align: :center, inline_format: true
      pdf.start_new_page

      pdf.column_box([0, pdf.cursor], columns: 2, width: pdf.bounds.width) do
        pdf.text generation_text, inline_format: true
      end
      pdf.start_new_page
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

    def print_generation(people)
      text = ''
      last_kbn = ''
      people.each do |person|
        if last_kbn = ''
          kbn = last_kbn = person.kbns.first
        else
          kbn = last_kbn = person.kbn_based_on_last_kbn(last_kbn)
        end
        person.relationships.each_with_index do |relationship, index|
          partner = Person.where(id: relationship.partner_ids).where.not(id: person.id).first rescue nil
          unless partner.nil?
            child_count = relationship.children.count
            if child_count > 0
              if person.primary_kbn == '812131'
                text << "<b>Children of Robin Lynette Turner (812131), adopted by husband Terry Bryant:</b>\n\n"
              elsif person.primary_kbn == '81332'
                text << "<b>Children of Brenda 'Joy' Adair (81332), adopted by second husband Marshell Grabeal:</b>\n\n"
              elsif person.primary_kbn == '9911'
                text << "<b>Children of Patricia Joyce Loudermilk (9911) and first husband Jimmie Heard, adopted by her second husband Thomas Walthier:</b>\n\n"
              elsif person.primary_kbn == '83511'
                text << "<b>Children of Michael Perry Goff (83511) and first wife Maggie Jones, adopted and raised by grandmother Minnie Louise Leifeste Gentry (8351):</b>\n\n"
              elsif person.primary_kbn == '5D21'
                text << "<b>Children of Katherine Jean Leifeste (5D21) and first husband William Ray Lentz, adopted by her second husband Burlen Horton:</b>\n\n"
              elsif person.primary_kbn == '5621'
                text << "<b>Children of Shirley Beth Grote (5621) and first husband Neely Roy Kight, adopted by her second husband William Lewis Lyles:</b>\n\n"
              elsif person.primary_kbn == '51111'
                text << "<b>Children of Glenda Marie Muennink (51111) and first husband Robert Brenner, adopted by her second husband Robert 'Bob' Gifford:</b>\n\n"
              elsif person.primary_kbn == '4833'
              elsif person.primary_kbn == '48331'
                text << "<b>Children of Cynthia Sue Follis Albert (48331) and first husband Sam Rager, adopted by Cynthia's parents Ruby Nell and Charlton Albert:</b>\n\n"
              elsif person.primary_kbn == '4761'
                text << "<b>Children of Wayne Dudley Woodress (4761) and first wife Bonnie Baker, adopted by his second wife Marylin Kay Salmon:</b>\n\n"
              elsif person.primary_kbn == '4744'
                text << "<b>Children of Merle Arleen Kothmann (4744) and first husband Brian Loren Mayott, adopted by her second husband Jerome Weaver:</b>\n\n"
              elsif person.primary_kbn == '47121'
                text << "<b>Children of Diane Loeffler (47121) and first husband Jammie Dwight Holland, adopted by her second husband David Whitworth:</b>\n\n"
              elsif person.primary_kbn == '43284'
                text << "<b>Children of Robin Kay Rusche (43284) and first husband Christopher Edward Monnier, adopted by her second husband Christopher Monnier:</b>\n\n"
              elsif person.primary_kbn == '432211'
                text << "<b>Children of Kathleen Gayle Coleman (432211) and first husband Rafeal Calvo Acofta, adopted by her second husband Leonard James Jared:</b>\n\n"
              elsif person.primary_kbn == '42531'
                text << "<b>Children of Linda Louise Lehmberg (42531) and first husband John Thomas 'Buster' Terrell, adopted by her second husband Michael Dean Lamkin:</b>\n\n"
              elsif person.primary_kbn == '357121'
                text << "<b>Children of Kara Rene Crouch (357121), adopted by her first husband Talor L. D. Hollingshead:</b>\n\n"
              elsif person.primary_kbn == '353211'
                text << "<b>Children of Kimberly Martin (353211) and first husband Jimmy Stiles, adopted by her second husband Harvey Metcalf:</b>\n\n"
              elsif person.primary_kbn == '342111'
                text << "<b>Children of Helen Frances Goode (342111) and first husband John Timothy Luton, adopted by her second husband Alexander Tong:</b>\n\n"
              elsif person.primary_kbn == '3334'
                text << "<b>Children of Lois Lorene Keller (3334) and first husband Roy Lester Tartt, adopted by her second husband Daryl Hansen:</b>\n\n"
              elsif person.primary_kbn == '122112'
                text << "<b>Children of Dawn Renay Osbourn (122112) and first husband Troy Saxbury, adopted by her second husband Brian Vance:</b>\n\n"
              elsif person.relationships.count > 1
                text << "<b>Children of #{person.name} (#{kbn}) and #{(index + 1).ordinalise} #{(person.male)? 'wife' : 'husband'} #{partner.name}:</b>\n\n"
              else
                text << "<b>Children of #{person.name} (#{kbn}) and #{partner.name}:</b>\n\n"
              end
              if person.primary_kbn == '4A32'
                relationship.children.order("kbns ASC").each_with_index do |child, index|
                  if index == 1
                    text << "<b>Children of Mary Anna Kothmann (4A32) and first husband Thomas Eugene Collier, adopted by grandfather Karl W. Kothmann:</b>\n\n"
                  end
                  text << print_person(child, kbn) + "\n"
                end
              elsif person.primary_kbn == '4833'
                relationship.children.order("kbns ASC").each_with_index do |child, index|
                  if index == 0
                    text << "<b>Children of Ruby Nell Kothmann (4833) and first husband David Ray Follis, adopted by her second husband Bryce Farmer:</b>\n\n"
                  elsif index == 1
                    text << "<b>Children of Ruby Nell Kothmann (4833) and first husband David Ray Follis, adopted by her third husband Charlton Albert:</b>\n\n"
                  end
                  text << print_person(child, kbn) + "\n"
                end
              else
                relationship.children.order("kbns ASC").each do |child|
                  text << print_person(child, kbn) + "\n"
                end
              end
            end
          end
        end
      end
      text
    end

    def print_person(person, parent_kbn)
      person_text = ''
      person_text << "#{person.primary_kbn}         #{person.name}, #{date_text(person, true, nil)}."
      person.relationships.each_with_index do |relationship, index|
        child_count = relationship.children.count
        partner = Person.where(id: relationship.partner_ids).where.not(id: person.id).first
        marriage_date = relationship.marriage_day
        divorced = (relationship.divorce_day.nil?)? false : true
        partner_kbn = (partner.primary_kbn.present?)? " (#{partner.primary_kbn})" : ''
        if index == 0
          person_text << "  Married #{(person.partners.count > 1)? (index + 1).ordinalise + ' ' : ''}#{(marriage_date.nil?)? '' : "in #{marriage_date} "}to:\n#{(divorced)? '**' : '*'}#{partner.name}#{partner_kbn}, #{date_text(partner, false, relationship.divorce_day)}"
        else
          person_text << "\n#{(divorced)? '**' : '*'}#{partner.name}#{partner_kbn} married #{(person.male)? 'him' : 'her'} #{(marriage_date.nil?)? '' : "in #{marriage_date}"}; #{date_text(partner, false, relationship.divorce_day)}"
        end
        person_text << "; #{pluralize(child_count, 'child')} by this union" if person.partners.count > 1
        person_text << '.'
        if person.primary_kbn.present? && partner.primary_kbn.present?
          child_kbn_root = relationship.children.first.primary_kbn[0..-2]
          if child_kbn_root == person.primary_kbn
            person_text << "\nAll children listed under #{person.name}'s KBN."
          else
            person_text << "\nAll children listed under #{partner.name}'s KBN."
          end
        end
        person_text << "\n" unless index == 0
      end

      count = person.descendants
      if count > 0
        person_text << "\n#{count} Total #{'descendant'.pluralize(count)}"
        count = Person.where.overlap(kbns: person.first_generation).where("LENGTH(primary_kbn) = 1").uniq.count
        if count > 0
          person_text << "\n#{pluralize(count, 'child').titleize}"
          count = Person.where.overlap(kbns: person.second_generation).where("LENGTH(primary_kbn) = 2").uniq.count
          if count > 0
            person_text << "\n#{pluralize(count, 'grandchild').titleize}"
            count = Person.where.overlap(kbns: person.third_generation).where("LENGTH(primary_kbn) = 3").uniq.count
            if count > 0
              person_text << "\n#{count} Great #{'grandchild'.pluralize(count)}"
              count = Person.where.overlap(kbns: person.fourth_generation).where("LENGTH(primary_kbn) = 4").uniq.count
              if count > 0
                person_text << "\n#{count} Great great #{'grandchild'.pluralize(count)}"
                count = Person.where.overlap(kbns: person.fifth_generation).where("LENGTH(primary_kbn) = 5").uniq.count
                if count > 0
                  person_text << "\n#{count} Great great great #{'grandchild'.pluralize(count)}"
                  count = Person.where.overlap(kbns: person.sixth_generation).where("LENGTH(primary_kbn) = 6").uniq.count
                  if count > 0
                    person_text << "\n#{count} Great great great great #{'grandchild'.pluralize(count)}"
                    count = Person.where.overlap(kbns: person.seventh_generation).where("LENGTH(primary_kbn) = 7").uniq.count
                    if count > 0
                      person_text << "\n#{count} Great great great great great #{'grandchild'.pluralize(count)}"
                      count = Person.where.overlap(kbns: person.eighth_generation).where("LENGTH(primary_kbn) = 8").uniq.count
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
      if person.adoption_type.present?
        adoption_type_initial = person.adoption_type[0,1]
        if adoption_type_initial == 'C'
        elsif adoption_type_initial == 'B'
          if person.adopted_day.present?
            adoption_text = "adopted #{person.adopted_day} by descendant"
          else
            adoption_text = "adopted, date unknown, by descendant"
          end
        elsif adoption_type_initial == 'A'
          if person.adopted_day.present?
            adoption_text = "adopted #{person.adopted_day}"
          else
            adoption_text = "adopted, date unknown"
          end
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
      date_text += "; #{adoption_text}" if adoption_text.present?
      date_text += "; #{death_text}" if death_text.present?
      date_text += "; Divorced #{divorce_day}" if divorce_day.present?
      date_text
    end
end
