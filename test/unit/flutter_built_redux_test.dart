import 'dart:async';

import 'package:built_redux/built_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

import 'test_models.dart';
import 'test_widget.dart';

void main() {
  Store<Counter, CounterBuilder, CounterActions> store;

  setUp(() {
    store = createStore();
  });

  tearDown(() async {
    await store.dispose();
  });

  group('flutter_built_redux: ', () {
    testWidgets('renders default state correctly', (WidgetTester tester) async {
      final providerWidget = new ProviderWidget(store);

      await tester.pumpWidget(providerWidget);

      CounterWidget counterWidget = tester.firstWidget(
        find.byKey(counterKey),
      );

      Text incrementTextWidget = tester.firstWidget(
        find.byKey(incrementTextKey),
      );

      expect(counterWidget.numBuilds, 1);
      expect(incrementTextWidget.data, 'Count: 0');
    });

    testWidgets('rerenders after increment', (WidgetTester tester) async {
      final widget = new ProviderWidget(store);

      await tester.pumpWidget(widget);

      CounterWidget counterWidget = tester.firstWidget(
        find.byKey(counterKey),
      );

      Text incrementTextWidget = tester.firstWidget(
        find.byKey(incrementTextKey),
      );

      expect(counterWidget.numBuilds, 1);
      expect(incrementTextWidget.data, 'Count: 0');

      await tester.tap(find.byKey(incrementButtonKey));
      await tester.pump();

      counterWidget = tester.firstWidget(
        find.byKey(counterKey),
      );

      incrementTextWidget = tester.firstWidget(
        find.byKey(incrementTextKey),
      );

      expect(counterWidget.numBuilds, 2);
      expect(incrementTextWidget.data, 'Count: 1');
    });

    testWidgets('does not rerender after update to other counter',
        (WidgetTester tester) async {
      final widget = new ProviderWidget(store);

      await tester.pumpWidget(widget);

      CounterWidget counterWidget = tester.firstWidget(
        find.byKey(counterKey),
      );

      Text incrementTextWidget = tester.firstWidget(
        find.byKey(incrementTextKey),
      );

      expect(counterWidget.numBuilds, 1);
      expect(incrementTextWidget.data, 'Count: 0');

      await tester.tap(find.byKey(incrementOtherButtonKey));
      await tester.pump();

      counterWidget = tester.firstWidget(
        find.byKey(counterKey),
      );

      incrementTextWidget = tester.firstWidget(
        find.byKey(incrementTextKey),
      );

      // pump should not cause a rebuild
      expect(counterWidget.numBuilds, 1);
      expect(incrementTextWidget.data, 'Count: 0');
    });
  });

  // group('StoreConnector', () {
  //   testWidgets('initially builds from the current state of the store',
  //       (WidgetTester tester) async {
  //     final initial = "initial";
  //     final widget = new StoreProvider(
  //       store: new Store(new IdentityReducer(), initialState: initial),
  //       child: new StoreBuilder(
  //         builder: (context, store) => new Text(
  //               store.state,
  //               textDirection: TextDirection.ltr,
  //             ),
  //       ),
  //     );

  //     await tester.pumpWidget(widget);

  //     expect(find.text(initial), findsOneWidget);
  //   });

  //   testWidgets('can convert the store to a ViewModel',
  //       (WidgetTester tester) async {
  //     final initial = "initial";
  //     final widget = new StoreProvider(
  //       store: new Store(new IdentityReducer(), initialState: initial),
  //       child: new StoreConnector(
  //         converter: (store) => store.state,
  //         builder: (context, latest) => new Text(
  //               latest,
  //               textDirection: TextDirection.ltr,
  //             ),
  //       ),
  //     );

  //     await tester.pumpWidget(widget);

  //     expect(find.text(initial), findsOneWidget);
  //   });

  //   testWidgets('builds the latest state of the store after a change event',
  //       (WidgetTester tester) async {
  //     final initial = "initial";
  //     final newState = "newState";
  //     final store = new Store(
  //       new IdentityReducer(),
  //       initialState: initial,
  //     );
  //     final widget = new StoreProvider(
  //       store: store,
  //       child: new StoreBuilder(
  //         builder: (context, store) {
  //           return new Text(
  //             store.state,
  //             textDirection: TextDirection.ltr,
  //           );
  //         },
  //       ),
  //     );

  //     // Build the widget with the initial state
  //     await tester.pumpWidget(widget);

  //     // Dispatch a new action
  //     store.dispatch(newState);

  //     // Build the widget again with the new state
  //     await tester.pumpWidget(widget);

  //     expect(find.text(newState), findsOneWidget);
  //   });

  //   testWidgets('rebuilds by default whenever the store emits a change',
  //       (WidgetTester tester) async {
  //     var numBuilds = 0;
  //     final initial = "initial";
  //     final store = new Store(
  //       new IdentityReducer(),
  //       initialState: initial,
  //     );
  //     final widget = new StoreProvider(
  //       store: store,
  //       child: new StoreConnector(
  //         converter: (store) => store.state,
  //         builder: (context, latest) {
  //           numBuilds++;

  //           return new Container();
  //         },
  //       ),
  //     );

  //     // Build the widget with the initial state
  //     await tester.pumpWidget(widget);

  //     expect(numBuilds, 1);

  //     // Dispatch the exact same event. This should still trigger a rebuild
  //     store.dispatch(initial);

  //     await tester.pumpWidget(widget);

  //     expect(numBuilds, 2);
  //   });

  //   testWidgets('does not rebuild if rebuildOnChange is set to false',
  //       (WidgetTester tester) async {
  //     var numBuilds = 0;
  //     final initial = "initial";
  //     final store = new Store(
  //       new IdentityReducer(),
  //       initialState: initial,
  //     );
  //     final widget = new StoreProvider(
  //       store: store,
  //       child: new StoreConnector(
  //         converter: (store) => store.state,
  //         rebuildOnChange: false,
  //         builder: (context, latest) {
  //           numBuilds++;

  //           return new Container();
  //         },
  //       ),
  //     );

  //     // Build the widget with the initial state
  //     await tester.pumpWidget(widget);

  //     expect(numBuilds, 1);

  //     // Dispatch the exact same event. This will cause a change on the Store,
  //     // but would result in no change to the UI since `rebuildOnChange` is
  //     // false.
  //     //
  //     // By default, this should still trigger a rebuild
  //     store.dispatch(initial);

  //     await tester.pumpWidget(widget);

  //     expect(numBuilds, 1);
  //   });

  //   testWidgets('does not rebuild if ignoreChange returns true',
  //       (WidgetTester tester) async {
  //     var numBuilds = 0;
  //     final initial = "initial";
  //     final store = new Store(
  //       new IdentityReducer(),
  //       initialState: initial,
  //     );
  //     final widget = new StoreProvider(
  //       store: store,
  //       child: new StoreConnector(
  //         ignoreChange: (dynamic state) => state == null,
  //         converter: (store) => store.state,
  //         builder: (context, latest) {
  //           numBuilds++;

  //           return new Container();
  //         },
  //       ),
  //     );

  //     // Build the widget with the initial state
  //     await tester.pumpWidget(widget);

  //     expect(numBuilds, 1);

  //     // Dispatch a null value. This will cause a change on the Store,
  //     // but would result in no rebuild since the `converter` is returning
  //     // this null value.
  //     store.dispatch(null);

  //     await tester.pumpWidget(widget);

  //     expect(numBuilds, 1);
  //   });

  //   testWidgets('StoreBuilder also runs a function when initialized',
  //       (WidgetTester tester) async {
  //     var numBuilds = 0;
  //     final action = "action";
  //     final onInit = new StoreCounter();
  //     final store = new Store(
  //       new IdentityReducer(),
  //       initialState: action,
  //     );
  //     final widget = () => new StoreProvider(
  //           store: store,
  //           child: new StoreBuilder(
  //             onInit: onInit,
  //             builder: (context, store) {
  //               numBuilds++;

  //               return new Container();
  //             },
  //           ),
  //         );

  //     // Build the widget with the initial state
  //     await tester.pumpWidget(widget());

  //     // Expect the Widget to be rebuilt and the onInit method to be called
  //     expect(onInit.callCount, 1);
  //     expect(numBuilds, 1);

  //     store.dispatch(action);

  //     // Rebuild the widget
  //     await tester.pumpWidget(widget());

  //     // Expect the Widget to be rebuilt, but the onInit method should NOT be
  //     // called a second time.
  //     expect(numBuilds, 2);
  //     expect(onInit.callCount, 1);

  //     store.dispatch("just to be sure");

  //     // Rebuild the widget
  //     await tester.pumpWidget(widget());

  //     // Expect the Widget to be rebuilt, but the onInit method should NOT be
  //     // called a third time.
  //     expect(numBuilds, 3);
  //     expect(onInit.callCount, 1);
  //   });

  //   testWidgets('StoreBuilder also runs a function when disposed',
  //       (WidgetTester tester) async {
  //     final action = "action";
  //     final onDispose = new StoreCounter();
  //     final store = new Store(
  //       new IdentityReducer(),
  //       initialState: action,
  //     );
  //     final widget = () => new StoreProvider(
  //           store: store,
  //           child: new StoreBuilder(
  //             onDispose: onDispose,
  //             builder: (context, store) => new Container(),
  //           ),
  //         );

  //     // Build the widget with the initial state
  //     await tester.pumpWidget(widget());

  //     expect(onDispose.callCount, 0);

  //     store.dispatch(action);

  //     // Rebuild a different widget, should trigger a dispose as the
  //     // StoreBuilder has been removed from the Widget tree.
  //     await tester.pumpWidget(new Container());

  //     expect(onDispose.callCount, 1);
  //   });

  //   testWidgets('optionally runs a function when the State is initialized',
  //       (WidgetTester tester) async {
  //     var numBuilds = 0;
  //     final action = "action";
  //     final onInit = new StoreCounter();
  //     final store = new Store(
  //       new IdentityReducer(),
  //       initialState: action,
  //     );
  //     final widget = () => new StoreProvider(
  //           store: store,
  //           child: new StoreConnector(
  //             onInit: onInit,
  //             converter: (store) => store.state,
  //             builder: (context, latest) {
  //               numBuilds++;

  //               return new Container();
  //             },
  //           ),
  //         );

  //     // Build the widget with the initial state
  //     await tester.pumpWidget(widget());

  //     // Expect the Widget to be rebuilt and the onInit method to be called
  //     expect(onInit.callCount, 1);
  //     expect(numBuilds, 1);

  //     store.dispatch(action);

  //     // Rebuild the widget
  //     await tester.pumpWidget(widget());

  //     // Expect the Widget to be rebuilt, but the onInit method should NOT be
  //     // called a second time.
  //     expect(numBuilds, 2);
  //     expect(onInit.callCount, 1);

  //     store.dispatch("just to be sure");

  //     // Rebuild the widget
  //     await tester.pumpWidget(widget());

  //     // Expect the Widget to be rebuilt, but the onInit method should NOT be
  //     // called a third time.
  //     expect(numBuilds, 3);
  //     expect(onInit.callCount, 1);
  //   });

  //   testWidgets('optionally runs a function when the State is disposed',
  //       (WidgetTester tester) async {
  //     final action = "action";
  //     final onDispose = new StoreCounter();
  //     final store = new Store(
  //       new IdentityReducer(),
  //       initialState: action,
  //     );
  //     final widget = () => new StoreProvider(
  //           store: store,
  //           child: new StoreConnector(
  //             onDispose: onDispose,
  //             converter: (store) => store.state,
  //             builder: (context, latest) => new Container(),
  //           ),
  //         );

  //     // Build the widget with the initial state
  //     await tester.pumpWidget(widget());

  //     // onDispose should not be called yet.
  //     expect(onDispose.callCount, 0);

  //     store.dispatch(action);

  //     // Rebuild a different widget tree. Expect this to trigger `onDispose`.
  //     await tester.pumpWidget(new Container());

  //     expect(onDispose.callCount, 1);
  //   });

  //   testWidgets(
  //       'avoids rebuilds when distinct is used with an object that implements ==',
  //       (WidgetTester tester) async {
  //     var numBuilds = 0;
  //     final initial = "initial";
  //     final store = new Store(
  //       new IdentityReducer(),
  //       initialState: initial,
  //     );
  //     final widget = new StoreProvider(
  //       store: store,
  //       child: new StoreConnector(
  //         // Same exact setup as the previous test, but distinct is set to true.
  //         distinct: true,
  //         converter: (store) => store.state,
  //         builder: (context, latest) {
  //           numBuilds++;

  //           return new Container();
  //         },
  //       ),
  //     );

  //     // Build the widget with the initial state
  //     await tester.pumpWidget(widget);

  //     expect(numBuilds, 1);

  //     // Dispatch another action of the same type
  //     store.dispatch(initial);

  //     await tester.pumpWidget(widget);

  //     expect(numBuilds, 1);

  //     // Dispatch another action of a different type. This should trigger another
  //     // rebuild
  //     store.dispatch("new");

  //     await tester.pumpWidget(widget);

  //     expect(numBuilds, 2);
  //   });
  // });
}
