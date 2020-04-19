// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemAdapter extends TypeAdapter<CartItem> {
  @override
  final typeId = 0;

  @override
  CartItem read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItem(
      productId: fields[1] as String,
      storeId: fields[0] as String,
    )..amount = fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, CartItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.storeId)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.amount);
  }
}
