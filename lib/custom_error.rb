module CustomError

    class ChatDisabled < StandardError; end
    class AlreadyAttending < StandardError; end
    class PackageAccess < StandardError; end
    class MaxAttendee < StandardError; end
    class PackagePurchase < StandardError; end
    class InvalidCard < StandardError; end
    class InvalidOmisePrice < StandardError; end
    class MissingRepresentativeCode < StandardError; end
    class InvalidLocalisation < StandardError; end
    class InvalidRepCode < StandardError; end
    class CurrentUserRepCodePresent < StandardError; end
end