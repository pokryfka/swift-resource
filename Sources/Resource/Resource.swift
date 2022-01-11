public enum Resource<T> {
    case placeholder
    case loading
    case failed(message: String)
    case available(T)
    case updating(T)
    case stale(T, message: String)
}

public extension Resource {
    var value: T? {
        switch self {
        case let .available(value):
            return value
        case let .updating(value):
            return value
        case let .stale(value, _):
            return value
        default:
            return nil
        }
    }

    var errorMessage: String? {
        switch self {
        case let .failed(message):
            return message
        case let .stale(_, message):
            return message
        default:
            return nil
        }
    }
}

public extension Resource {
    func map<U>(_ mapper: (T) -> U) -> Resource<U> {
        switch self {
        case .placeholder:
            return .placeholder
        case .loading:
            return .loading
        case let .failed(message):
            return .failed(message: message)
        case let .available(value):
            return .available(mapper(value))
        case let .updating(value):
            return .updating(mapper(value))
        case let .stale(value, message):
            return .stale(mapper(value), message: message)
        }
    }
}

extension Resource: Equatable where T: Equatable {}

extension Resource: Codable where T: Codable {
    enum Discriminator: String, Codable {
        case unavailable
        case available
    }

    enum CodingKeys: String, CodingKey {
        case __type
        case value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(Discriminator.self, forKey: .__type)
        switch type {
        case .unavailable:
            self = .placeholder
        case .available:
            let value = try container.decode(T.self, forKey: .value)
            self = .available(value)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .placeholder, .loading, .failed:
            try container.encode(Discriminator.unavailable, forKey: .__type)
        case let .available(value), let .updating(value), let .stale(value, _):
            try container.encode(Discriminator.available, forKey: .__type)
            try container.encode(value, forKey: .value)
        }
    }
}
