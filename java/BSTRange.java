package A3Q1;

/**
 * Extends the TreeMap class to allow convenient access to entries within a
 * specified range of key values (findAllInRange).
 * 
 */
public class BSTRange<K, V> extends TreeMap<K, V> {

	/*
	 * Returns the lowest (deepest) position in the subtree rooted at pos that
	 * is a common ancestor to positions with keys k1 and k2, or to the
	 * positions they would occupy were they present.
	 */
	protected Position<Entry<K, V>> findLowestCommonAncestor(K k1, K k2,
			Position<Entry<K, V>> pos) {
		// implement this method
		if (pos.getElement().getKey() == null) {
			return null;
		} else if (this.compare(pos.getElement().getKey(), k1) < 0) {
			return findLowestCommonAncestor(k1, k2, this.tree.right(pos));

		} else if (this.compare(pos.getElement().getKey(), k2) > 0) {
			return findLowestCommonAncestor(k1, k2, this.tree.left(pos));
		}
		return pos;
	}

	/*
	 * Finds all entries in the subtree rooted at pos with keys of k or greater
	 * and copies them to L, in non-decreasing order.
	 */
	protected void findAllAbove(K k, Position<Entry<K, V>> pos,
			PositionalList<Entry<K, V>> L) {
		// implement this method
		PositionalList<Entry<K, V>> list = L;
		if (this.compare(pos.getElement().getKey(), k) < 0) {
			if (this.tree.right(pos).getElement() != null) {
				this.findAllAbove(k, this.tree.right(pos), list);
			}
		} else if (this.compare(pos.getElement().getKey(), k) >= 0) {
			if (this.tree.left(pos).getElement() != null) {
				this.findAllAbove(k, this.tree.left(pos), list);
			}
			list.addLast(pos.getElement());
			if (this.tree.right(pos).getElement() != null) {
				this.findAllAbove(k, this.tree.right(pos), list);
			}
		}
	}

	/*
	 * Finds all entries in the subtree rooted at pos with keys of k or less and
	 * copies them to L, in non-decreasing order.
	 */
	protected void findAllBelow(K k, Position<Entry<K, V>> pos,
			PositionalList<Entry<K, V>> L) {
		// implement this method
		PositionalList<Entry<K, V>> list = L;
		if (this.compare(pos.getElement().getKey(), k) > 0) {
			if (this.tree.left(pos).getElement() != null) {
				this.findAllBelow(k, this.tree.left(pos), list);
			}
		} else if (this.compare(pos.getElement().getKey(), k) <= 0) {
			if (this.tree.left(pos).getElement() != null) {
				this.findAllBelow(k, this.tree.left(pos), list);
			}
			list.addLast(pos.getElement());
			if (this.tree.right(pos).getElement() != null) {
				this.findAllBelow(k, this.tree.right(pos), list);
			}
		}
	}

	/*
	 * Returns all entries with keys no less than k1 and no greater than k2, in
	 * non-decreasing order.
	 */
	public PositionalList<Entry<K, V>> findAllInRange(K k1, K k2) {
		// implement this method
		PositionalList<Entry<K, V>> list = new LinkedPositionalList();
		if (this.compare(k1, k2) > 0) {
			return list;
		} else if ((int) k1 < 0 && (int) k2 < 0) {
			return list;
		} else if (this.tree.size() == 1) {
			return list;
		} else {
			Position<Entry<K, V>> pos = this.findLowestCommonAncestor(k1, k2,
					this.tree.root());
			if (this.tree.left(pos).getElement() != null) {
				this.findAllAbove(k1, this.tree.left(pos), list);
			}
			list.addLast(pos.getElement());
			if (this.tree.right(pos).getElement() != null) {
				this.findAllBelow(k2, this.tree.right(pos), list);
			}
			return list;
		}
	}
}
