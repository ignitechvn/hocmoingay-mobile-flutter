class BankTheoryPageSidebarItemDto {
  final String id;
  final String title;
  final String? parentId;
  final List<BankTheoryPageSidebarItemDto> children;
  final int order;

  BankTheoryPageSidebarItemDto({
    required this.id,
    required this.title,
    this.parentId,
    required this.children,
    required this.order,
  });

  factory BankTheoryPageSidebarItemDto.fromJson(Map<String, dynamic> json) {
    return BankTheoryPageSidebarItemDto(
      id: json['id'] as String,
      title: json['title'] as String,
      parentId: json['parentId'] as String?,
      children:
          (json['children'] as List<dynamic>?)
              ?.map(
                (child) => BankTheoryPageSidebarItemDto.fromJson(
                  child as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (parentId != null) 'parentId': parentId,
      'children': children.map((child) => child.toJson()).toList(),
      'order': order,
    };
  }
}

class BankTheoryPageSidebarResponseDto {
  final List<BankTheoryPageSidebarItemDto> items;
  final int totalCount;

  BankTheoryPageSidebarResponseDto({
    required this.items,
    required this.totalCount,
  });

  factory BankTheoryPageSidebarResponseDto.fromJson(Map<String, dynamic> json) {
    return BankTheoryPageSidebarResponseDto(
      items: (json['items'] as List<dynamic>)
          .map(
            (item) => BankTheoryPageSidebarItemDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      totalCount: json['totalCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'totalCount': totalCount,
    };
  }
}
