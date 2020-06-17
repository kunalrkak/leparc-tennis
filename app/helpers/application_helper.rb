module ApplicationHelper

    def author_of(record)
        user_signed_in? && current_user.id == record.user_id
    end

    def admin?
        user_signed_in? && current_user.admin?
    end

    def printTime(time)
        time.strftime("%I:%M %p")
    end

    def printTimeIndex(time)
        time.strftime("%l %p")
    end

    def printDate(date)
        date.strftime("%A, %B #{date.day.ordinalize}, %Y")
    end

    def printDateShort(date)
        date.strftime("%D")
    end

    def printDateTimeShort(date)
        date.strftime("%D %R")
    end

    def street_options
        ['Almond Cir.', 'Almond Ct.', 'Chestnut Ct.', 'Eastern Cir.', 'Eastern Dr.', 'Elm Ct.', 
        'Hickory Ct.', 'Le Parc Ct.', 'Le Parc Dr.', 'Poplar Ct.', 'Redwood Ct.', 'Walnut Ct.']
    end
end
