import "package:flutter_test/flutter_test.dart";
import "package:miria/repository/account_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

void main() {
  test("MiAuthで管理者向けの権限を要求しないこと", () {
    expect(
      miAuthPermissions.where((p) => p.value.contains(":admin:")),
      isEmpty,
    );
  });

  test("MiAuthで一般の権限は要求すること", () {
    expect(
      miAuthPermissions,
      containsAll([
        Permission.readAccount,
        Permission.writeNotes,
        Permission.writeDrive,
        Permission.readChat,
        Permission.writeChat,
      ]),
    );
  });
}
