

struct PokeDetailsFormatter {
    
    let name: String
    let type: String
    let height: String
    let weight: String
    
    init?(pokeDetails: PokemonDetail) {
        let name = pokeDetails.name
        let id = pokeDetails.id
        let types = pokeDetails.types
        let height = pokeDetails.height
        let weight = pokeDetails.weight
        
        let koreanName = PokemonTranslator.getKoreanName(for: name)
        
        let type = PokeDetailsFormatter.formatTypes(types)
        
        self.name = "No.\(id)  \(koreanName)"
        self.type = "타입: \(type)"
        self.height = "키: \(Double(height) / 10) m"
        self.weight = "몸무게: \(Double(weight) / 10) kg"
    }
    
    private static func formatTypes(_ types: [PokemonType]) -> String {
        return types
            .map { PokemonTypeName(rawValue: $0.type.name)?.displayName ?? $0.type.name }
            .joined(separator: ", ")
    }
}
