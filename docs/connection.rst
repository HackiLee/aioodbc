Connection
==========

The library provides a way to connect to ODBC databases.

Example::

  @asyncio.coroutine
  def go():
      conn = yield from aiopg.connect(database='aiopg',
                                      user='aiopg',
                                      password='secret',
                                      host='127.0.0.1')
      cur = yield from conn.cursor()
      yield from cur.execute("SELECT * FROM tbl")
      ret = yield from cur.fetchall()


.. function:: connect(dsn=None, *, loop=None, timeout=60.0, \
                      enable_json=True, enable_hstore=True, echo=False, \
                      **kwargs)

   A :ref:`coroutine <coroutine>` that connects to PostgreSQL.

   The function accepts all parameters that :func:`psycopg2.connect`
   does plus optional keyword-only *loop* and *timeout* parameters.

   :param loop: asyncio event loop instance or ``None`` for default one.

   :param float timeout: default timeout (in seconds) for connection operations.

                         60 secs by default.

   :param bool enable_json: enable json column types for connection.

                         ``True`` by default.

   :param bool enable_hstore: try to enable hstore column types for connection.

                         ``True`` by default.

                         For using HSTORE columns extension should be
                         installed in database first::

                             CREATE EXTENSION HSTORE

   :param bool echo: log executed SQL statement (``False`` by default).

   :returns: :class:`Connection` instance.


.. class:: Connection

   A connection to a :term:`PostgreSQL` database instance. It encapsulates a
   database session.

   Its insterface is very close to :class:`psycopg2.connection`
   (http://initd.org/psycopg/docs/connection.html) except all methods
   are :ref:`coroutines <coroutine>`.

   Use :func:`connect` for creating connection.

   The most important method is

   .. method:: cursor(name=None, cursor_factory=None, \
               scrollable=None, withhold=False, *, timeout=None)

      A :ref:`coroutine <coroutine>` that creates a new cursor object
      using the connection.

      The only *cursor_factory* can be specified, all other
      parameters are not supported by :term:`psycopg2` in
      asynchronous mode yet.

      The *cursor_factory* argument can be used to create
      non-standard cursors. The argument must be a subclass of
      `psycopg2.extensions.cursor`. See :ref:`subclassing-cursor` for
      details. A default factory for the connection can also be
      specified using the :attr:`Connection.cursor_factory` attribute.

      *timeout* is a timeout for returned cursor instance if
      parameter is not `None`.

      *name*, *scrollable* and *withhold* parameters are not supported
      by :term:`psycopg2` in asynchronous mode.

      :returns: :class:`Cursor` instance.

   .. method:: close()

      Immediatelly close the connection.

      Close the connection now (rather than whenever `del` is executed).
      The connection will be unusable from this point forward; an
      `psycopg2.InterfaceError` will be raised if any operation is
      attempted with the connection.  The same applies to all cursor objects
      trying to use the connection.  Note that closing a connection without
      committing the changes first will cause any pending change to be
      discarded as if a ``ROLLBACK`` was performed.

      .. versionchanged:: 0.5

         :meth:`close` is regular function now.  For sake of backward
         compatibility the method returns :class:`asyncio.Future`
         instance with result already set to ``None`` (you still can
         use ``yield from conn.close()`` construction.

   .. attribute:: closed

      The readonly property that returns ``True`` if connections is closed.

   .. attribute:: echo

      Return *echo mode* status. Log all executed queries to logger
      named ``aiopg`` if ``True``

   .. attribute:: raw

      The readonly property that underlying
      :class:`psycopg2.connection` instance.

