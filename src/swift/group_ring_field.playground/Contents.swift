
/*
 群の定義
 */

protocol Group: Equatable {
    // 演算 (演算子オーバーロードをしている)
    static func *(a: Self, b: Self) -> Self
    // 群の元 (read only)
    static var identity: Self {get}
    // 群の逆元 (read only)
    var inverse: Self {get}
}

// 群を成立させるためのテストたち
extension Group {
    // 結束性があることの証明
    static func testAssociativity(a:Self, _ b: Self, _ c: Self) -> Bool {
        return (a * b) * c == a * (b * c)
    }
    
    // 単位元であることの証明
    static func testIdentity(a: Self) -> Bool {
        return (a * Self.identity == a) && (Self.identity * a == a)
    }
    
    // 逆元があることの証明
    static func testInverse(a: Self) -> Bool {
        return (a * a.inverse == Self.identity) && (a.inverse * a == Self.identity)
    }
}



/*
 加法群
 →演算+を持つ群
 （加法群というときは演算の可換性を仮定することが多い）
 */

protocol AdditiveGroup: Equatable {
    // 加法群の演算
    static func +(a: Self, b: Self) -> Self
    
    // 単行演算「-」が逆元
    prefix static func -(a: Self) -> Self
    
    // 単位元
    static var zero: Self { get }
    
    func -<G: AdditiveGroup>(a: G, b: G) -> G {
        return (a + (-b))
    }
}

extension AdditiveGroup {
    // 結束性があることの証明
    static func testAssociativity(a:Self, _ b: Self, _ c: Self) -> Bool {
        return (a * b) * c == a * (b * c)
    }
    
    // 単位元であることの証明
    static func testIdentity(a: Self) -> Bool {
        return (a * Self.identity == a) && (Self.identity * a == a)
    }
    
    // 逆元があることの証明
    static func testInverse(a: Self) -> Bool {
        return (a * a.inverse == Self.identity) && (a.inverse * a == Self.identity)
    }
}

// 整数群GrZ
typealias GrZ = Int
// intのクラスに新たに単位元を追加する
extension GrZ: AdditiveGroup {
    static var zero: Z { return 0 }
}



/*
 モノイドの定義
 1. 演算が集合内に閉じていること
 2. 結合法則と単位元を持つこと
 (逆元がないだけ？)
 */

protocol Monoid: Equatable {
    static func *(a: Self, b: Self) -> Self
    static var identity: Self { get }
}


/*
  環の定義
  集合Rに演算+,*があり、以下を満たすときRを環という:
  1. Rは+に関して可換群である(ex. +に関する単位元を0,aの逆元を-aとかく)
  2. Rは*に関してモノイド(such as 逆元がない群)である(ex. *に関する単位元を1とかく) -> 積に関しては逆元が存在しないという点で群でないことがわかる
  3. 分配性を持つ(ただの分配法則のこと)
    ex. 任意のa,b,c ∈ Rに対して以下が成り立つ
        - (a + b) * c = a * c + b * c
        - a * (a + b) = a * b + a * c
  */


protocol Ring: AdditiveGroup, Monoid {
    init(_ initValue: Int)
}

extension Ring {
    static var zero: Self {
        return Self.init(0)
    }

    static var identity: Self {
        return Self.init(1)
    }
}

// 整数環RiZ
typealias RiZ = Int
extension RiZ: Ring { }



/*
 体の定義
 集合Fが二つの演算+,*に関して体を成し、F - {0}が*に関して群を成すとき、Fを体という。
 */

protocol Field: Group, Ring {
    func /<F: Field>(a: F, b: F) -> F {
        return a * b.inverse
    }
}

// 実数体R
typealias R = Double
extension R: Field {
    var inverse: R {
        return 1 / self
    }
}
